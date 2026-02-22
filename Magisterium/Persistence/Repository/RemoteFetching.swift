//
//  RemoteFetching.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-20.
//

import Combine

protocol RemoteFetching {
	associatedtype DTO: Decodable
	func fetchAll() -> AnyPublisher<[DTO], NetworkError>
}
