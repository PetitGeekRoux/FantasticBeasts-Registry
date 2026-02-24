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
	private let mapper = SpellMapper()
	private let remote: SpellRemoteFetching

	init(remote: SpellRemoteFetching = SpellRemoteSource()) {
		self.remote = remote
	}

	func bootstrapIfNeeded(context: ModelContext) {
		do {
			let existing = try context.fetch(FetchDescriptor<Spell>())
			guard existing.isEmpty else { return }

			remote
				.fetchAll()
				.receive(on: DispatchQueue.main)
				.sink { completion in
					if case .failure(let error) = completion {
						print("Remote error: \(error)")
					}
				} receiveValue: { [weak self] dtos in
					guard let self else { return }
					do {
						for dto in dtos {
							try self.upsert(dto, in: context)
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

	private func upsert(_ dto: SpellDto, in context: ModelContext) throws {
		let predicate = #Predicate<Spell> { $0.id == dto.id }
		let descriptor = FetchDescriptor<Spell>(predicate: predicate)
		if let existing = try context.fetch(descriptor).first {
			mapper.update(existing, with: dto)
		} else {
			let entity = mapper.makeEntity(from: dto)
			context.insert(entity)
		}
	}
}
