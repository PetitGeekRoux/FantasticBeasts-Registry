//
//  NetworkClient.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-20.
//

import Foundation
import Combine

final class NetworkClient {
    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: Endpoint,
                               decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, NetworkError> {
        do {
            let request = try endpoint.makeRequest(baseURL: baseURL)
            return session.dataTaskPublisher(for: request)
                .tryMap { data, response -> Data in
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw NetworkError.invalidResponse
                    }
                    guard (200...299).contains(httpResponse.statusCode) else {
                        throw NetworkError.serverError(httpResponse.statusCode)
                    }
                    return data
                }
                .decode(type: T.self, decoder: decoder)
                .mapError { error in
                    if error is DecodingError { return .decodingError }
                    return (error as? NetworkError) ?? .invalidResponse
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
    }
}
