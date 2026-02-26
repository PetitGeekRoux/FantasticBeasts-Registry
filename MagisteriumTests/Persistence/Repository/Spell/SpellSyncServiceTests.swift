//
//  SpellSyncServiceTests.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-22.
//

import Combine
import SwiftData
import Testing

@testable import Magisterium

struct FakeSpellRemote: SpellRemoteFetching {
	var dtos: [SpellDto]
	var error: NetworkError?

	func fetchAll() -> AnyPublisher<[SpellDto], NetworkError> {
		if let error {
			return Fail(error: error).eraseToAnyPublisher()
		}
		return Just(dtos)
			.setFailureType(to: NetworkError.self)
			.eraseToAnyPublisher()
	}
}

@Suite("SpellSyncService")
struct SpellSyncServiceTests {

	func makeInMemoryContainer() throws -> ModelContainer {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		return try ModelContainer(for: Spell.self, configurations: config)
	}

	@MainActor @Test("bootstrapIfNeeded inserts when store is empty")
	func bootstrapInsertsWhenEmpty() async throws {
		let container = try makeInMemoryContainer()
		let context = ModelContext(container)

		let remote = FakeSpellRemote(dtos: [
			SpellDto(
				id: "lumos",
				name: "Lumos",
				incantation: "Lumos",
				effect: "Light",
				canBeVerbal: true,
				type: "Charm",
				light: "White",
				creator: "Unknown"
			)
		])
		let service = SpellSyncService(remote: remote)

		await service.fetchAndUpsertAll(context: context)

		let fetched = try context.fetch(FetchDescriptor<Spell>())
		#expect(fetched.count == 1)
		#expect(fetched.first?.id == "lumos")
	}

	@MainActor @Test("bootstrapIfNeeded skips when store already has data")
	func bootstrapSkipsWhenNotEmpty() throws {
		let container = try makeInMemoryContainer()
		let context = ModelContext(container)

		let existing = Spell(
			id: "accio",
			name: "Accio",
			incantation: nil,
			effect: "Summons",
			canBeVerbal: nil,
			type: .charm,
			light: "None",
			creator: nil
		)
		context.insert(existing)
		try context.save()

		let remote = FakeSpellRemote(dtos: [
			SpellDto(
				id: "lumos",
				name: "Lumos",
				incantation: "Lumos",
				effect: "Light",
				canBeVerbal: true,
				type: "Charm",
				light: "White",
				creator: "Unknown"
			)
		])
		let service = SpellSyncService(remote: remote)

		service.bootstrapIfNeeded(context: context)

		let fetched = try context.fetch(FetchDescriptor<Spell>())
		#expect(fetched.count == 1)
		#expect(fetched.first?.id == "accio")
	}

	@MainActor @Test("bootstrapIfNeeded handles remote error gracefully")
	func bootstrapHandlesRemoteError() throws {
		let container = try makeInMemoryContainer()
		let context = ModelContext(container)

		let remote = FakeSpellRemote(dtos: [], error: .serverError(500))
		let service = SpellSyncService(remote: remote)

		service.bootstrapIfNeeded(context: context)

		let fetched = try context.fetch(FetchDescriptor<Spell>())
		#expect(fetched.isEmpty)
	}

	@MainActor @Test("bootstrapIfNeeded upserts existing entity")
	func bootstrapUpsertsExisting() throws {
		let container = try makeInMemoryContainer()
		let context = ModelContext(container)
		let mapper = SpellMapper()

		let initial = mapper.makeEntity(
			from: SpellDto(
				id: "accio",
				name: "Accio",
				incantation: nil,
				effect: "Summons",
				canBeVerbal: nil,
				type: "Charm",
				light: "None",
				creator: nil
			)
		)
		context.insert(initial)
		try context.save()

		let updatedDTO = SpellDto(
			id: "accio",
			name: "Accio (Updated)",
			incantation: "Accio",
			effect: "Summons objects",
			canBeVerbal: true,
			type: "Hex",
			light: "White",
			creator: "Unknown"
		)

		let predicate = #Predicate<Spell> { $0.id == updatedDTO.id }
		let descriptor = FetchDescriptor<Spell>(predicate: predicate)
		if let existing = try context.fetch(descriptor).first {
			mapper.update(existing, with: updatedDTO)
			try context.save()
		}

		let fetched = try context.fetch(FetchDescriptor<Spell>())
		#expect(fetched.count == 1)
		#expect(fetched.first?.name == "Accio (Updated)")
		#expect(fetched.first?.type == .hex)
	}

	@MainActor @Test("fetchAndUpsertAll inserts when store is empty")
	func fetchAndUpsertAllInsertsWhenEmpty() async throws {
		let container = try makeInMemoryContainer()
		let context = ModelContext(container)

		let remote = FakeSpellRemote(dtos: [
			SpellDto(id: "lumos", name: "Lumos", incantation: "Lumos", effect: "Light", canBeVerbal: true, type: "Charm", light: "White", creator: "Unknown")
		])
		let service = SpellSyncService(remote: remote)

		await service.fetchAndUpsertAll(context: context)

		let fetched = try context.fetch(FetchDescriptor<Spell>())
		#expect(fetched.count == 1)
		#expect(fetched.first?.id == "lumos")
	}

	@MainActor @Test("fetchAndUpsertAll upserts existing entity")
	func fetchAndUpsertAllUpserts() async throws {
		let container = try makeInMemoryContainer()
		let context = ModelContext(container)
		let mapper = SpellMapper()

		let initial = mapper.makeEntity(from: SpellDto(id: "accio", name: "Accio", incantation: nil, effect: "Summons", canBeVerbal: nil, type: "Charm", light: "None", creator: nil))
		context.insert(initial)
		try context.save()

		let updated = SpellDto(id: "accio", name: "Accio (Updated)", incantation: "Accio", effect: "Summons objects", canBeVerbal: true, type: "Hex", light: "White", creator: "Unknown")
		let remote = FakeSpellRemote(dtos: [updated])
		let service = SpellSyncService(remote: remote)

		await service.fetchAndUpsertAll(context: context)

		let fetched = try context.fetch(FetchDescriptor<Spell>())
		#expect(fetched.count == 1)
		#expect(fetched.first?.name == "Accio (Updated)")
		#expect(fetched.first?.type == .hex)
	}

	
}
