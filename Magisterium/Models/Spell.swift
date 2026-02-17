//
//  Spell.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-14.
//

import Foundation

struct Spell: Identifiable, Codable {
	let id: String
	let name: String
	let incantation: String?
	let effect: String
	let canBeVerbal: Bool?
	var type: SpellType
	let light: String
	let creator: String?
}
