//
//  NetworkService.swift
//  FantasticBeasts
//
//  Created by Kevin St-Pierre on 2026-02-14.
//

import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(Int)
}

class NetworkService {
    static let shared = NetworkService()
    private let baseURL = "https://wizard-world-api.herokuapp.com"
    
    private init() {}
    
    func fetchSpells() -> AnyPublisher<[Spell], NetworkError> {
        guard let url = URL(string: "\(baseURL)/Spells") else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
		return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
				print(data)
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.serverError(httpResponse.statusCode)
                }
                return data
            }
            .decode(type: [Spell].self, decoder: JSONDecoder())
            .mapError { error in
				print(error)

                if error is DecodingError {
                    return NetworkError.decodingError
                }
                return error as? NetworkError ?? NetworkError.invalidResponse
            }
            .eraseToAnyPublisher()
    }
}
