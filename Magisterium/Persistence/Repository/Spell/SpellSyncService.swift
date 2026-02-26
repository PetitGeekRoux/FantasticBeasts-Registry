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

	init(remote: SpellRemoteFetching) {
		self.remote = remote
	}

	convenience init() {
		self.init(remote: SpellRemoteSource())
	}

	func bootstrapIfNeeded(context: ModelContext) {
		do {
			let existing = try context.fetch(FetchDescriptor<Spell>())
			guard existing.isEmpty else { return }
			Task { await fetchAndUpsertAll(context: context) }
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

@MainActor
extension SpellSyncService {
	func fetchAndUpsertAll(context: ModelContext) async {
		do {
			let dtos = await fetchAllDTOsAsync()

			for dto in dtos {
				try upsert(dto, in: context)
			}

			try context.save()
		} catch {
			print("fetchAndUpsertAll error: \(error)")
		}
	}

	private func fetchAllDTOsAsync() async -> [SpellDto] {
		await withCheckedContinuation { continuation in
			var cancellable: AnyCancellable?
			cancellable = remote.fetchAll()
				.sink(
					receiveCompletion: { completion in
						if case .failure = completion {
							continuation.resume(returning: [])  // en cas d'erreur, renvoyer [] ou utilisez withCheckedThrowingContinuation
						}
					},
					receiveValue: { dtos in
						continuation.resume(returning: dtos)
						_ = cancellable  // garder la référence vivante
					}
				)
		}
	}
}
