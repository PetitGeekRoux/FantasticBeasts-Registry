//
//  Spell.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-20.
//

import Foundation
import SwiftData

@Model
final class Spell: Identifiable {
    @Attribute(.unique) var id: String
    var name: String
    var incantation: String?
    var effect: String
    var canBeVerbal: Bool?
    var typeRaw: String
    var light: String
    var creator: String?

    // Computed convenience for UI using your existing SpellType enum
    var type: SpellType {
        get { SpellType(rawValue: typeRaw) ?? .charm }
        set { typeRaw = newValue.rawValue }
    }

    init(
        id: String,
        name: String,
        incantation: String?,
        effect: String,
        canBeVerbal: Bool?,
        type: SpellType,
        light: String,
        creator: String?
    ) {
        self.id = id
        self.name = name
        self.incantation = incantation
        self.effect = effect
        self.canBeVerbal = canBeVerbal
        self.typeRaw = type.rawValue
        self.light = light
        self.creator = creator
    }
}

// MARK: - Mapping from DTO
extension Spell {
    convenience init(from dto: SpellDto) {
        self.init(
            id: dto.id,
            name: dto.name,
            incantation: dto.incantation,
            effect: dto.effect,
            canBeVerbal: dto.canBeVerbal,
            type: SpellType(rawValue: dto.type) ?? .charm,
            light: dto.light,
            creator: dto.creator
        )
    }
}
