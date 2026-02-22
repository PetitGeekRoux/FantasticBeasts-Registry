//
//  SpellListViewModel.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-14.
//

import Foundation
import Combine

final class SpellListViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var activeFilters: FilterOptions = .none

    func filterSpells(from spells: [Spell]) -> [Spell] {
        var result = spells
        
        if !searchQuery.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
        }
		if !activeFilters.types.isEmpty {
			result = result.filter { activeFilters.types.contains($0.type) }
        }
        return result
    }
}

struct FilterOptions: Equatable {
    var types: Set<SpellType> = []
    static let none = FilterOptions()
}
