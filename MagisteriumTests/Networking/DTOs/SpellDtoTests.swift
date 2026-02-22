//
//  SpellDtoTests.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-21.
//


import Testing
@testable import Magisterium

@MainActor @Suite("SpellDto Codable")
struct SpellDtoTests {

    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    @Test("Decodes a complete valid JSON")
    func decodesCompleteJSON() throws {
        let json = """
        {
            "id": "lumos",
            "name": "Lumos",
            "incantation": "Lumos",
            "effect": "Creates a beam of light.",
            "canBeVerbal": true,
            "type": "Charm",
            "light": "White",
            "creator": "Unknown"
        }
        """.data(using: .utf8)!

        let dto = try decoder.decode(SpellDto.self, from: json)

        #expect(dto.id == "lumos")
        #expect(dto.name == "Lumos")
        #expect(dto.incantation == "Lumos")
        #expect(dto.effect == "Creates a beam of light.")
        #expect(dto.canBeVerbal == true)
        #expect(dto.type == "Charm")
        #expect(dto.light == "White")
        #expect(dto.creator == "Unknown")
    }

    @Test("Decodes with missing optional fields")
    func decodesMissingOptionals() throws {
        let json = """
        {
            "id": "accio",
            "name": "Accio",
            "effect": "Summons an object.",
            "type": "Charm",
            "light": "None"
        }
        """.data(using: .utf8)!

        let dto = try decoder.decode(SpellDto.self, from: json)

        #expect(dto.incantation == nil)
        #expect(dto.canBeVerbal == nil)
        #expect(dto.creator == nil)
        #expect(dto.id == "accio")
        #expect(dto.name == "Accio")
        #expect(dto.effect == "Summons an object.")
        #expect(dto.type == "Charm")
        #expect(dto.light == "None")
    }

    @Test("Ignores unknown fields in JSON")
    func ignoresUnknownFields() throws {
        let json = """
        {
            "id": "mystery",
            "name": "Mystery",
            "effect": "Unknown effect.",
            "type": "Hex",
            "light": "Dark",
            "unknownField": "shouldBeIgnored",
            "anotherOne": 123
        }
        """.data(using: .utf8)!

        let dto = try decoder.decode(SpellDto.self, from: json)

        #expect(dto.id == "mystery")
        #expect(dto.name == "Mystery")
        #expect(dto.effect == "Unknown effect.")
        #expect(dto.type == "Hex")
        #expect(dto.light == "Dark")
        // Les champs inconnus n'existent pas dans dto, donc rien à vérifier de plus.
    }

    @Test("Encodes to JSON with expected keys")
    func encodesToJSON() throws {
        let dto = SpellDto(
            id: "protego",
            name: "Protego",
            incantation: "Protego",
            effect: "Shields the caster.",
            canBeVerbal: true,
            type: "Charm",
            light: "None",
            creator: "Unknown"
        )

        encoder.outputFormatting = [.sortedKeys] // pour des snapshots lisibles si besoin
        let data = try encoder.encode(dto)
        let jsonString = String(data: data, encoding: .utf8) ?? ""

        // Vérifications basiques
        #expect(jsonString.contains("\"id\":\"protego\""))
        #expect(jsonString.contains("\"name\":\"Protego\""))
        #expect(jsonString.contains("\"incantation\":\"Protego\""))
        #expect(jsonString.contains("\"effect\":\"Shields the caster.\""))
        #expect(jsonString.contains("\"canBeVerbal\":true"))
        #expect(jsonString.contains("\"type\":\"Charm\""))
        #expect(jsonString.contains("\"light\":\"None\""))
        #expect(jsonString.contains("\"creator\":\"Unknown\""))
    }

    @Test("Decodes an array of SpellDto")
    func decodesArray() throws {
        let json = """
        [
            { "id": "lumos", "name": "Lumos", "effect": "Light", "type": "Charm", "light": "White" },
            { "id": "accio", "name": "Accio", "effect": "Summons", "type": "Charm", "light": "None" }
        ]
        """.data(using: .utf8)!

        let dtos = try decoder.decode([SpellDto].self, from: json)
        #expect(dtos.count == 2)
        #expect(dtos.first?.id == "lumos")
        #expect(dtos.last?.name == "Accio")
    }
}
