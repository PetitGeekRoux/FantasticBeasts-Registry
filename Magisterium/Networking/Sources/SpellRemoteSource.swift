//
//  SpellRemoteSource.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-20.
//

import Foundation
import Combine

struct SpellRemoteSource {
	private let client = NetworkClient(baseURL: URL(string: "https://wizard-world-api.herokuapp.com")!)

    func fetchAll() -> AnyPublisher<[SpellDto], NetworkError> {
        let endpoint = Endpoint(path: "/Spells")
        return client.request(endpoint)
    }
}
