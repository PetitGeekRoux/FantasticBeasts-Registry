//
//  Beast.swift
//  FantasticBeasts
//
//  Created by Kevin St-Pierre on 2026-02-14.
//

struct Beast: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let imageURL: URL?
    let category: BeastCategory
    let habitat: String
    let abilities: [String]
    
//    var dangerLevel: MOMClassification {
//        MOMClassificationCalculator.calculate(for: self)
//    }
	var dangerLevel: MOMClassification { .harmless }
}
