//
//  SpellType.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-14.
//

enum SpellType: String, Codable, CaseIterable {
	case none = "None"
	case charm = "Charm"
	case conjuration = "Conjuration"
	case spell = "Spell"
	case transfiguration = "Transfiguration"
	case healingSpell = "HealingSpell"
	case darkCharm = "DarkCharm"
	case jinx = "Jinx"
	case curse = "Curse"
	case magicalTransportation = "MagicalTransportation"
	case hex = "Hex"
	case counterSpell = "CounterSpell"
	case darkArts = "DarkArts"
	case counterJinx = "CounterJinx"
	case counterCharm = "CounterCharm"
	case untransfiguration = "Untransfiguration"
	case bindingMagicalContract = "BindingMagicalContract"
	case vanishment = "Vanishment"
}
