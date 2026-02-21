//
//  ContentView.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-13.
//

import SwiftUI

struct ContentView: View {
	@Environment(\.modelContext) private var modelContext

	private let spellSync = SpellSyncService()

	var body: some View {

		SpellListView()
			.task {
				spellSync.bootstrapIfNeeded(context: modelContext)
			}
	}
}

#Preview {
	ContentView()
}
