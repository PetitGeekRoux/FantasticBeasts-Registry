//
//  SpellIdentifier.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-20.
//

struct SpellIdentifier: DTOIdentifying {
    func id(from dto: SpellDto) -> String { dto.id }
    static var idKeyPath: KeyPath<Spell, String> { \.id }
}
