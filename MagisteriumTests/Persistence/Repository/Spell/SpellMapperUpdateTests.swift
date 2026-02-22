//
//  SpellMapperUpdateTests.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-22.
//


import Testing
@testable import Magisterium

@Suite("SpellMapper update")
struct SpellMapperUpdateTests {

    @Test("Updates all mutable fields")
    func updatesAllFields() {
        var spell = Spell(
            id: "accio",
            name: "Accio",
            incantation: nil,
            effect: "Summons",
            canBeVerbal: nil,
            type: .charm,
            light: "None",
            creator: nil
        )

        let dto = SpellDto(
            id: "accio", // même id
            name: "Accio (Updated)",
            incantation: "Accio",
            effect: "Summons objects",
            canBeVerbal: true,
            type: "Hex",
            light: "White",
            creator: "Unknown"
        )

        let mapper = SpellMapper()
        mapper.update(spell, with: dto)

        #expect(spell.name == "Accio (Updated)")
        #expect(spell.incantation == "Accio")
        #expect(spell.effect == "Summons objects")
        #expect(spell.canBeVerbal == true)
        #expect(spell.type == .hex)
        #expect(spell.light == "White")
        #expect(spell.creator == "Unknown")
    }

    @Test("Keeps id unchanged on update")
    func keepsIdUnchanged() {
        let originalId = "lumos"
        let spell = Spell(
            id: originalId,
            name: "Lumos",
            incantation: "Lumos",
            effect: "Light",
            canBeVerbal: true,
            type: .charm,
            light: "White",
            creator: "Unknown"
        )

        let dto = SpellDto(
            id: "different-id", // même si le DTO a un autre id, on ne touche pas à l'id de l'entité
            name: "Lumos (Updated)",
            incantation: nil,
            effect: "Light beam",
            canBeVerbal: nil,
            type: "Charm",
            light: "White",
            creator: nil
        )

        let mapper = SpellMapper()
        mapper.update(spell, with: dto)

        #expect(spell.id == originalId)
        #expect(spell.name == "Lumos (Updated)")
        #expect(spell.effect == "Light beam")
    }
}