//
//  SpellListViewModel.swift
//  FantasticBeasts
//
//  Created by Kevin St-Pierre on 2026-02-14.
//

import Foundation
import Combine

class SpellListViewModel: ObservableObject {
    @Published var spells: [Spell] = []
    @Published var filteredSpells: [Spell] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchQuery = ""
    @Published var activeFilters: FilterOptions = .none
    
    private let networkService: NetworkService
    private var cancellables = Set<AnyCancellable>()
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
        setupBindings()
    }
    
    func fetchSpells() {
        isLoading = true
        errorMessage = nil
        
        networkService.fetchSpells()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = self?.handleError(error)
                }
            } receiveValue: { [weak self] spells in
                self?.spells = spells
            }
            .store(in: &cancellables)
    }
    
    private func setupBindings() {
        Publishers.CombineLatest3($spells, $searchQuery, $activeFilters)
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .map { spells, query, filters in
                self.filterSpells(spells, query: query, filters: filters)
            }
            .assign(to: &$filteredSpells)
    }
    
    private func filterSpells(_ spells: [Spell], query: String, filters: FilterOptions) -> [Spell] {
        var result = spells
        
        if !query.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(query) }
        }
        
        if !filters.types.isEmpty {
            result = result.filter { filters.types.contains($0.type) }
        }
        
        return result
    }
    
    private func handleError(_ error: NetworkError) -> String {
        switch error {
        case .invalidURL:
            return "URL invalide"
        case .invalidResponse:
            return "Réponse serveur invalide"
        case .decodingError:
            return "Erreur de décodage des données"
        case .serverError(let code):
            return "Erreur serveur (Code: \(code))"
        }
    }
}

struct FilterOptions: Equatable {
    var types: Set<SpellType> = []

    static let none = FilterOptions()
}
