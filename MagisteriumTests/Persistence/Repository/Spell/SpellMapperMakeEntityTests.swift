//
//  SpellMapperMakeEntityTests.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-22.
//

import Testing

@testable import Magisterium

@Suite("SpellMapper makeEntity")
struct SpellMapperMakeEntityTests {

	@Test("Maps all fields from DTO to Spell")
	func mapsAllFields() {
		let dto = SpellDto(
			id: "lumos",
			name: "Lumos",
			incantation: "Lumos",
			effect: "Creates a beam of light.",
			canBeVerbal: true,
			type: "Charm",
			light: "White",
			creator: "Unknown"
		)

		let mapper = SpellMapper()
		let spell = mapper.makeEntity(from: dto)

		#expect(spell.id == "lumos")
		#expect(spell.name == "Lumos")
		#expect(spell.incantation == "Lumos")
		#expect(spell.effect == "Creates a beam of light.")
		#expect(spell.canBeVerbal == true)
		#expect(spell.type == .charm)
		#expect(spell.light == "White")
		#expect(spell.creator == "Unknown")
	}

	@Test("Handles missing optionals correctly")
	func handlesMissingOptionals() {
		let dto = SpellDto(
			id: "accio",
			name: "Accio",
			incantation: nil,
			effect: "Summons an object.",
			canBeVerbal: nil,
			type: "Charm",
			light: "None",
			creator: nil
		)

		let mapper = SpellMapper()
		let spell = mapper.makeEntity(from: dto)

		#expect(spell.incantation == nil)
		#expect(spell.canBeVerbal == nil)
		#expect(spell.creator == nil)
		#expect(spell.type == .charm)
	}

	@Test("Falls back to .charm when type is unknown")
	func fallbackTypeWhenUnknown() {
		let dto = SpellDto(
			id: "mystery",
			name: "Mystery",
			incantation: nil,
			effect: "Unknown effect",
			canBeVerbal: nil,
			type: "TotallyUnknownType",
			light: "Dark",
			creator: nil
		)

		let mapper = SpellMapper()
		let spell = mapper.makeEntity(from: dto)

		#expect(spell.type == .charm)
	}
}
