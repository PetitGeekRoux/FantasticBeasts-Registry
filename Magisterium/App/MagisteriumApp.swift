//
//  MagisteriumApp.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-13.
//

import SwiftUI
import SwiftData

@main
struct MagisteriumApp: App {
	
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Spell.self])
    }
}
