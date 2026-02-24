//
//  SpellRemoteFetching.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-22.
//

import Combine

protocol SpellRemoteFetching {
    func fetchAll() -> AnyPublisher<[SpellDto], NetworkError>
}
