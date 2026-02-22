//
//  SpellListView.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-14.
//

import SwiftData
import SwiftUI

struct SpellListView: View {
	@Query(sort: \Spell.name) private var allSpells: [Spell]
	@StateObject private var vm = SpellListViewModel()

	var body: some View {
		NavigationStack {
			List(vm.filterSpells(from: allSpells)) { spell in
				NavigationLink(destination: SpellDetailView(spell: spell)) {
					SpellRowView(spell: spell)
				}
			}
			.navigationTitle("Spells")
			.searchable(text: $vm.searchQuery, prompt: "Search a spell")
			#if os(iOS)
				.listStyle(.insetGrouped)
			#else
				.listStyle(.inset)
			#endif
		}
	}
}
