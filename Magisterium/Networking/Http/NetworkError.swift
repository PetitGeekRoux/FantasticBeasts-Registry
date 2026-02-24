//
//  NetworkError.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-21.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(Int)
}
