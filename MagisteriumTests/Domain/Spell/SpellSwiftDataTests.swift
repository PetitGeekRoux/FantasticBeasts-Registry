//
//  SpellSwiftDataTests.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-21.
//

import SwiftData
import Testing

@testable import Magisterium

@Suite("Spell SwiftData integration (in-memory)")
struct SpellSwiftDataTests {

	func makeInMemoryContainer() throws -> ModelContainer {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		return try ModelContainer(for: Spell.self, configurations: config)
	}

	@Test("Insert and fetch")
	func insertAndFetch() throws {
		let container = try makeInMemoryContainer()
		let context = ModelContext(container)

		let spell = Spell(
			id: "lumos",
			name: "Lumos",
			incantation: "Lumos",
			effect: "Light",
			canBeVerbal: true,
			type: .charm,
			light: "White",
			creator: "Unknown"
		)

		context.insert(spell)
		try context.save()

		let fetched = try context.fetch(FetchDescriptor<Spell>())
		#expect(fetched.count == 1)
		#expect(fetched.first?.id == "lumos")
	}

	@Test("Update and persist")
	func updateAndPersist() throws {
		let container = try makeInMemoryContainer()
		let context = ModelContext(container)

		let spell = Spell(
			id: "accio",
			name: "Accio",
			incantation: nil,
			effect: "Summons",
			canBeVerbal: nil,
			type: .charm,
			light: "None",
			creator: nil
		)

		context.insert(spell)
		try context.save()

		spell.name = "Accio (Updated)"
		try context.save()

		let fetched = try context.fetch(FetchDescriptor<Spell>())
		#expect(fetched.first?.name == "Accio (Updated)")
	}

	@Test("Upsert updates existing entity instead of duplicating")
	func upsertUpdatesEntity() throws {
		let container = try makeInMemoryContainer()
		let context = ModelContext(container)
		let mapper = SpellMapper()

		// Insert initial spell
		let initial = Spell(
			id: "same",
			name: "S1",
			incantation: nil,
			effect: "E1",
			canBeVerbal: nil,
			type: .charm,
			light: "L",
			creator: nil
		)
		context.insert(initial)
		try context.save()

		// Upsert with dto
		let dto = SpellDto(
			id: "same",
			name: "S2",
			incantation: nil,
			effect: "E2",
			canBeVerbal: nil,
			type: "Hex",
			light: "L",
			creator: nil
		)

		// upsert (reprenez votre logique du service)
		let predicate = #Predicate<Spell> { $0.id == dto.id }
		let descriptor = FetchDescriptor<Spell>(predicate: predicate)
		if let existing = try context.fetch(descriptor).first {
			mapper.update(existing, with: dto)
		} else {
			context.insert(mapper.makeEntity(from: dto))
		}
		try context.save()

		// Assert: un seul élément, mis à jour
		let fetched = try context.fetch(FetchDescriptor<Spell>())
		#expect(fetched.count == 1)
		#expect(fetched.first?.name == "S2")
		#expect(fetched.first?.effect == "E2")
		#expect(fetched.first?.type == .hex)
	}
}
