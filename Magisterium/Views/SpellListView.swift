//
//  SpellListView.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-14.
//

import SwiftUI

struct SpellListView: View {
    @StateObject private var viewModel = SpellListViewModel()
    @State private var showFilters = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Spells loading...")
                } else if let error = viewModel.errorMessage {
//                    ErrorView(message: error) {
//                        viewModel.fetchSpells()
//                    }
					Text(error)
                } else {
                    spellListContent
                }
            }
            .navigationTitle("Spells")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showFilters = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
//                FilterView(filters: $viewModel.activeFilters)
            }
            .searchable(text: $viewModel.searchQuery, prompt: "Search a spell")
            .onAppear {
                if viewModel.spells.isEmpty {
                    viewModel.fetchSpells()
                }
            }
        }
    }
    
    private var spellListContent: some View {
        List(viewModel.filteredSpells) { spell in
            NavigationLink(destination: SpellDetailView(spell: spell)) {
                SpellRowView(spell: spell)
            }
        }
#if os(iOS)
        .listStyle(.insetGrouped)
#else
        .listStyle(.inset)
#endif
    }
}

struct SpellRowView: View {
    let spell: Spell

    var body: some View {
        HStack(spacing: 12) {
//            AsyncImage(url: spell.imageURL) { image in
//                image.resizable().scaledToFill()
//            } placeholder: {
//                Color.gray.opacity(0.3)
//            }
//            .frame(width: 60, height: 60)
//            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(spell.name)
                    .font(.headline)
                
                Text(spell.type.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

				if spell.incantation != nil  {
					Text(spell.incantation!)
						.font(.caption)
				}
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

