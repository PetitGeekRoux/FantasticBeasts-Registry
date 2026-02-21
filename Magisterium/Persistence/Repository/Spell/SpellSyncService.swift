//
//  SpellSyncService.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-20.
//

import Combine
import SwiftData

@MainActor
final class SpellSyncService {
    private var cancellables = Set<AnyCancellable>()

    func bootstrapIfNeeded(context: ModelContext) {
        do {
            let existing = try context.fetch(FetchDescriptor<Spell>())
            guard existing.isEmpty else { return }

            SpellRemoteSource()
                .fetchAll()
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print("Remote error: \(error)")
                    }
                } receiveValue: { dtos in
                    do {
                        for dto in dtos {
                            context.insert(Spell(from: dto))
                        }
                        try context.save()
                    } catch {
                        print("Save error: \(error)")
                    }
                }
                .store(in: &cancellables)
        } catch {
            print("Fetch error: \(error)")
        }
    }
}
