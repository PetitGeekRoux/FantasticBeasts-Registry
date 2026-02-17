//
//  MOMClassification.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-14.
//

enum MOMClassification: Int, Comparable {
    case boring = 1      // X
    case harmless = 2    // XX
    case manageable = 3  // XXX
    case dangerous = 4   // XXXX
    case killer = 5      // XXXXX
    
    var stars: String {
        String(repeating: "⭐", count: rawValue)
    }
    
    static func < (lhs: MOMClassification, rhs: MOMClassification) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
