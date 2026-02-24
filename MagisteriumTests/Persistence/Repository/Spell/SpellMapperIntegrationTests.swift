//
//  SpellMapperIntegrationTests.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-22.
//


import Testing
import SwiftData
@testable import Magisterium

@Suite("SpellMapper + SwiftData integration (in-memory)")
struct SpellMapperIntegrationTests {

    func makeInMemoryContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: Spell.self, configurations: config)
    }

    @Test("End-to-end upsert with mapper")
    func endToEndUpsert() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)
        let mapper = SpellMapper()

        let initialDTO = SpellDto(
            id: "accio",
            name: "Accio",
            incantation: nil,
            effect: "Summons",
            canBeVerbal: nil,
            type: "Charm",
            light: "None",
            creator: nil
        )
        let initial = mapper.makeEntity(from: initialDTO)
        context.insert(initial)
        try context.save()

        let updatedDTO = SpellDto(
            id: "accio",
            name: "Accio (Updated)",
            incantation: "Accio",
            effect: "Summons objects",
            canBeVerbal: true,
            type: "Hex",
            light: "White",
            creator: "Unknown"
        )

        let predicate = #Predicate<Spell> { $0.id == updatedDTO.id }
        let descriptor = FetchDescriptor<Spell>(predicate: predicate)
        if let existing = try context.fetch(descriptor).first {
            mapper.update(existing, with: updatedDTO)
        } else {
            context.insert(mapper.makeEntity(from: updatedDTO))
        }
        try context.save()

        let fetchedAll = try context.fetch(FetchDescriptor<Spell>())
        #expect(fetchedAll.count == 1)
        let fetched = fetchedAll.first
        #expect(fetched?.id == "accio")
        #expect(fetched?.name == "Accio (Updated)")
        #expect(fetched?.incantation == "Accio")
        #expect(fetched?.effect == "Summons objects")
        #expect(fetched?.canBeVerbal == true)
        #expect(fetched?.type == .hex)
        #expect(fetched?.light == "White")
        #expect(fetched?.creator == "Unknown")
    }
}
