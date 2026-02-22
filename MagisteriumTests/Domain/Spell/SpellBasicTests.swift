//
//  SpellBasicTests.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-21.
//


import Testing
@testable import Magisterium

@Suite("Spell basic initialization")
struct SpellBasicTests {

    @Test("Initializes with all fields")
    func initializesAllFields() throws {
        let spell = Spell(
            id: "lumos",
            name: "Lumos",
            incantation: "Lumos",
            effect: "Creates a beam of light.",
            canBeVerbal: true,
            type: .charm,
            light: "White",
            creator: "Unknown"
        )

        #expect(spell.id == "lumos")
        #expect(spell.name == "Lumos")
        #expect(spell.incantation == "Lumos")
        #expect(spell.effect == "Creates a beam of light.")
        #expect(spell.canBeVerbal == true)
        #expect(spell.type == .charm)
        #expect(spell.light == "White")
        #expect(spell.creator == "Unknown")
    }

    @Test("Handles optional properties being nil")
    func handlesOptionals() throws {
        let spell = Spell(
            id: "accio",
            name: "Accio",
            incantation: nil,
            effect: "Summons an object.",
            canBeVerbal: nil,
            type: .charm,
            light: "None",
            creator: nil
        )

        #expect(spell.incantation == nil)
        #expect(spell.canBeVerbal == nil)
        #expect(spell.creator == nil)
    }
}