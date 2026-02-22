//
//  GenericSyncService.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-20.
//


import SwiftData
import Combine

@MainActor
final class GenericSyncService<Remote: RemoteFetching, Mapper: DTOMapper, Identifier: DTOIdentifying> where
    Remote.DTO == Mapper.DTO,
    Mapper.Entity == Identifier.Entity,
    Remote.DTO == Identifier.DTO
{
    private let remote: Remote
    private let mapper: Mapper
    private let identifier: Identifier

    private var cancellables = Set<AnyCancellable>()

    init(remote: Remote, mapper: Mapper, identifier: Identifier) {
        self.remote = remote
        self.mapper = mapper
        self.identifier = identifier
    }

    func bootstrapIfNeeded(context: ModelContext) {
        do {
            let descriptor = FetchDescriptor<Identifier.Entity>()
            let existing = try context.fetch(descriptor)
            guard existing.isEmpty else { return }
            fetchAndUpsertAll(context: context)
        } catch {
            print("SwiftData fetch error: \(error)")
        }
    }

    func fetchAndUpsertAll(context: ModelContext) {
        remote.fetchAll()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Remote fetch error: \(error)")
                }
            } receiveValue: { [weak self] dtos in
                guard let self else { return }
                do {
                    for dto in dtos {
                        try self.upsert(dto, in: context)
                    }
                    try context.save()
                } catch {
                    print("SwiftData save error: \(error)")
                }
            }
            .store(in: &cancellables)
    }

    func upsert(_ dto: Remote.DTO, in context: ModelContext) throws {
        let id = identifier.id(from: dto)
        let all = try context.fetch(FetchDescriptor<Identifier.Entity>())
        if let existing = all.first(where: { $0[keyPath: Identifier.idKeyPath] == id }) {
            mapper.update(existing, with: dto)
        } else {
            let entity = mapper.makeEntity(from: dto)
            context.insert(entity)
        }
    }
}

