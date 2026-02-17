//
//  MOMClassificationCalculator.swift
//  FantasticBeasts
//
//  Created by Kevin St-Pierre on 2026-02-14.
//

import Foundation

struct MOMClassificationCalculator {
	static func calculate(for beast: Beast) -> MOMClassification {

		let aggressiveness = extractAggressiveness(from: beast)
		let rarity = extractRarity(from: beast)
		let controllability = extractControllability(from: beast)
		let intelligence = extractIntelligence(from: beast)

		let rating = MOMClassificationEngine.calculateClassification(
			withAggressiveness: aggressiveness,
			rarity: rarity,
			controllability: controllability,
			intelligence: intelligence
		)

		return MOMClassification(rawValue: Int(rating)) ?? .boring
	}

	private static func extractAggressiveness(from beast: Beast) -> Double {

		let aggressiveKeywords = [
			"dangerous", "aggressive", "deadly", "vicious",
		]
		let matches = aggressiveKeywords.filter {
			beast.description.lowercased().contains($0)
		}
		return Double(matches.count) / Double(aggressiveKeywords.count)
	}

	private static func extractRarity(from beast: Beast) -> Double {

		let rarityKeywords = [
			"dangerous", "aggressive", "deadly", "vicious",
		]
		let matches = rarityKeywords.filter {
			beast.description.lowercased().contains($0)
		}
		return Double(matches.count) / Double(rarityKeywords.count)
	}

	private static func extractControllability(from beast: Beast) -> Double {

		let controllabilityKeywords = [
			"dangerous", "aggressive", "deadly", "vicious",
		]
		let matches = controllabilityKeywords.filter {
			beast.description.lowercased().contains($0)
		}
		return Double(matches.count) / Double(controllabilityKeywords.count)
	}

	private static func extractIntelligence(from beast: Beast) -> Double {

		let intelligenceKeywords = [
			"dangerous", "aggressive", "deadly", "vicious",
		]
		let matches = intelligenceKeywords.filter {
			beast.description.lowercased().contains($0)
		}
		return Double(matches.count) / Double(intelligenceKeywords.count)
	}

}
