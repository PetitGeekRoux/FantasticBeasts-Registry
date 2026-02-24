//
//  HTTPClient.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-21.
//

import Combine

protocol HTTPClient {
	func request<T: Decodable>(
		_ endpoint: Endpoint,
		decoder: JSONDecoder
	) -> AnyPublisher<T, NetworkError>
}
