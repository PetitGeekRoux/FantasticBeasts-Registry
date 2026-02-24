//
//  SpellIdentifierTests.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-21.
//

import Testing

@testable import Magisterium

@Suite("SpellIdentifier basics")
struct SpellIdentifierTests {

	@Test("id(from:) returns dto.id")
	func idFromDto() {
		let dto = SpellDto(
			id: "lumos",
			name: "Lumos",
			incantation: "Lumos",
			effect: "Light",
			canBeVerbal: true,
			type: "Charm",
			light: "White",
			creator: "Unknown"
		)

		let identifier = SpellIdentifier()
		let extracted = identifier.id(from: dto)

		#expect(extracted == "lumos")
	}

	@Test("idKeyPath points to Spell.id")
	func idKeyPathPointsToSpellId() {
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

		let value = spell[keyPath: SpellIdentifier.idKeyPath]
		#expect(value == "accio")
	}
}
