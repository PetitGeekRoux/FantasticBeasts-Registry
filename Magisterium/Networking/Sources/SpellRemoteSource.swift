//
//  SpellRemoteSource.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-20.
//

import Foundation
import Combine

struct SpellRemoteSource {
	private let client: HTTPClient

	init(client: HTTPClient = NetworkClient(baseURL: URL(string: "https://wizard-world-api.herokuapp.com")!)) {
		self.client = client
	}


    func fetchAll() -> AnyPublisher<[SpellDto], NetworkError> {
        let endpoint = Endpoint(path: "/Spells")
		return client.request(endpoint, decoder: JSONDecoder())
    }
}

extension SpellRemoteSource: SpellRemoteFetching {}
