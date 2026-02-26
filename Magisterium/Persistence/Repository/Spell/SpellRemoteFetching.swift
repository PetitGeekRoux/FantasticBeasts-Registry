//
//  SpellRemoteFetching.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-22.
//

import Combine

protocol SpellRemoteFetching {
	func fetchAll() -> AnyPublisher<[SpellDto], NetworkError>
	func fetchAllAsync() async throws -> [SpellDto]
}

extension SpellRemoteFetching {
	func fetchAllAsync() async throws -> [SpellDto] {
		try await withCheckedThrowingContinuation { continuation in
			var cancellable: AnyCancellable?
			cancellable = fetchAll().sink(
				receiveCompletion: { completion in
					if case .failure(let error) = completion {
						continuation.resume(throwing: error)
					}
				},
				receiveValue: { value in
					continuation.resume(returning: value)
					_ = cancellable
				}
			)
		}
	}
}
