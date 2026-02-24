//
//  SpellIdentifierIntegrationTests.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-21.
//

import SwiftData
import Testing

@testable import Magisterium

@Suite("SpellIdentifier integration with SwiftData")
struct SpellIdentifierIntegrationTests {

	func makeInMemoryContainer() throws -> ModelContainer {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		return try ModelContainer(for: Spell.self, configurations: config)
	}

	@Test("Fetch by id using idKeyPath predicate")
	func fetchByIdUsingKeyPath() throws {
		let container = try makeInMemoryContainer()
		let context = ModelContext(container)

		// Insérer deux spells
		let s1 = Spell(
			id: "lumos",
			name: "Lumos",
			incantation: "Lumos",
			effect: "Light",
			canBeVerbal: true,
			type: .charm,
			light: "White",
			creator: "Unknown"
		)
		let s2 = Spell(
			id: "accio",
			name: "Accio",
			incantation: nil,
			effect: "Summons",
			canBeVerbal: nil,
			type: .charm,
			light: "None",
			creator: nil
		)
		context.insert(s1)
		context.insert(s2)
		try context.save()

		// Construire un predicate avec idKeyPath
		let targetId = "accio"
		let predicate = #Predicate<Spell> { entity in
			entity.id == targetId
		}
		let descriptor = FetchDescriptor<Spell>(predicate: predicate)

		let fetched = try context.fetch(descriptor)
		#expect(fetched.count == 1)
		#expect(fetched.first?.id == "accio")
	}
}
