//
//  SpellRemoteSourceTests.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-21.
//

import Combine
import Testing

@testable import Magisterium

// Un faux client qui renvoie des données préparées
struct FakeHTTPClient: HTTPClient {
	let data: Data
	let decodeError: Bool

	init(jsonString: String, decodeError: Bool = false) {
		self.data = Data(jsonString.utf8)
		self.decodeError = decodeError
	}

	func request<T>(_ endpoint: Endpoint, decoder: JSONDecoder) -> AnyPublisher<
		T, NetworkError
	> where T: Decodable {
		if decodeError {
			return Fail(error: .decodingError).eraseToAnyPublisher()
		}
		do {
			let value = try decoder.decode(T.self, from: data)
			return Just(value)
				.setFailureType(to: NetworkError.self)
				.eraseToAnyPublisher()
		} catch {
			return Fail(error: .decodingError).eraseToAnyPublisher()
		}
	}
}

@MainActor @Suite("SpellRemoteSource") struct SpellRemoteSourceTests {
	@Test("fetchAll decodes array of SpellDto")
	func fetchAllDecodesArray() async throws {
		let json = """
			[
			    { "id": "lumos", "name": "Lumos", "effect": "Light", "type": "Charm", "light": "White" },
			    { "id": "accio", "name": "Accio", "effect": "Summons", "type": "Charm", "light": "None" }
			]
			"""

		let fakeClient = FakeHTTPClient(jsonString: json)
		let source = SpellRemoteSource(client: fakeClient)

		let dtos: [SpellDto] = try await withCheckedThrowingContinuation {
			continuation in
			var cancellable: AnyCancellable?
			cancellable = source.fetchAll()
				.sink(
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

		#expect(dtos.count == 2)
		#expect(dtos.first?.id == "lumos")
		#expect(dtos.last?.name == "Accio")
	}

	@Test("fetchAll emits decoding error on invalid JSON")
	func fetchAllDecodingError() async throws {
		let invalidJSON = """
			{ "id": "notAnArray" }
			"""
		let fakeClient = FakeHTTPClient(jsonString: invalidJSON)
		let source = SpellRemoteSource(client: fakeClient)

		do {
			let _: [SpellDto] = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[SpellDto], Error>) in
				var cancellable: AnyCancellable?
				cancellable = source.fetchAll()
					.sink(
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
			Issue.record("Expected decoding error but got success")
		} catch let error as NetworkError {
			#expect(error == .decodingError)
		} catch {
			Issue.record("Expected NetworkError.decodingError but got \(error)")
		}
	}
}

