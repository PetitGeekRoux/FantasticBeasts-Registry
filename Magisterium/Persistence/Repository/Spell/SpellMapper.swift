//
//  SpellMapper.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-20.
//

struct SpellMapper: DTOMapper {

	func makeEntity(from dto: SpellDto) -> Spell {
		Spell(
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

    func update(_ entity: Spell, with dto: SpellDto) {
        entity.name = dto.name
        entity.incantation = dto.incantation
        entity.effect = dto.effect
        entity.canBeVerbal = dto.canBeVerbal
        entity.type = SpellType(rawValue: dto.type) ?? .charm
        entity.light = dto.light
        entity.creator = dto.creator
    }
}
