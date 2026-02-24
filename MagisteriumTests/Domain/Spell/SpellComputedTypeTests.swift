//
//  SpellComputedTypeTests.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-21.
//


import Testing
@testable import Magisterium

@Suite("Spell computed property 'type'")
struct SpellComputedTypeTests {

    @Test("Reading type reflects typeRaw")
    func getTypeReflectsRaw() throws {
        let spell = Spell(
            id: "test",
            name: "Test",
            incantation: nil,
            effect: "Effect",
            canBeVerbal: nil,
            type: .curse,
            light: "None",
            creator: nil
        )
        #expect(spell.type == .curse)
    }

    @Test("Setting type updates typeRaw")
    func setTypeUpdatesRaw() throws {
        let spell = Spell(
            id: "test2",
            name: "Test2",
            incantation: nil,
            effect: "Effect",
            canBeVerbal: nil,
            type: .charm,
            light: "None",
            creator: nil
        )

        spell.type = .hex
        #expect(spell.type == .hex)
    }
}