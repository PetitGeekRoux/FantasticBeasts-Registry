//
//  DTOIdentifying.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-20.
//

import SwiftData

protocol DTOIdentifying {
    associatedtype DTO
    associatedtype Entity: PersistentModel
	
	func id(from dto: DTO) -> String
    static var idKeyPath: KeyPath<Entity, String> { get }
}
