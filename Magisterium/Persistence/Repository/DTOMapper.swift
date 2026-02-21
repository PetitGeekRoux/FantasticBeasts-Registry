//
//  DTOMapper.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-20.
//


import SwiftData

protocol DTOMapper {
    associatedtype DTO
    associatedtype Entity: PersistentModel

    func makeEntity(from dto: DTO) -> Entity
    func update(_ entity: Entity, with dto: DTO)
}
