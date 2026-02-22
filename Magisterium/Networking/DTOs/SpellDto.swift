//
//  SpellDto.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-20.
//

import Foundation

struct SpellDto: Codable {
	let id: String
	let name: String
	let incantation: String?
	let effect: String
	let canBeVerbal: Bool?
	let type: String
	let light: String
	let creator: String?
}
