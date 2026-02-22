//
//  SpellRowView.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-21.
//

import SwiftUI

struct SpellRowView: View {
	let spell: Spell

	var body: some View {
		HStack(spacing: 12) {
			VStack(alignment: .leading, spacing: 4) {
				Text(spell.name)
					.font(.headline)

				Text(spell.type.rawValue)
					.font(.subheadline)
					.foregroundColor(.secondary)

				if spell.incantation != nil {
					Text(spell.incantation!)
						.font(.caption)
				}
			}

			Spacer()
		}
		.padding(.vertical, 4)
	}
}
