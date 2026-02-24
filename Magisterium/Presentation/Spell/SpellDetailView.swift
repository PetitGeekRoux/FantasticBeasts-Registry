//
//  SpellDetailView.swift
//  Magisterium
//
//  Created by Kevin St-Pierre on 2026-02-13.
//

import SwiftUI

struct SpellDetailView: View {
	let spell: Spell

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {
				// Image placeholder if an image URL exists in the model
				// Uncomment and adjust if `Spell` exposes `imageURL`
				// AsyncImage(url: spell.imageURL) { image in
				//     image.resizable().scaledToFill()
				// } placeholder: {
				//     Color.gray.opacity(0.2)
				// }
				// .frame(height: 200)
				// .clipShape(RoundedRectangle(cornerRadius: 12))

				Text(spell.name)
					.font(.largeTitle)
					.fontWeight(.bold)

				HStack(spacing: 8) {
					Text("Type:")
						.font(.headline)
					Text(spell.type.rawValue)
						.foregroundColor(.secondary)
				}

				if spell.incantation != nil
					&& spell.incantation!.isEmpty {
					VStack(alignment: .leading, spacing: 8) {
						Text("Incantation")
							.font(.headline)
						Text(spell.incantation!)
							.font(.body)
					}
				}
				Spacer(minLength: 0)
			}
			.padding()
		}
		.navigationTitle(spell.name)
		#if os(iOS) || os(tvOS) || os(watchOS)
			.navigationBarTitleDisplayMode(.inline)
		#endif
	}
}

#Preview {
	SpellDetailView(
		spell: Spell(
			id: "preview-lumos",
			name: "Lumos",
			incantation: "Lumos",
			effect: "Creates a narrow beam of light from the caster's wand.",
			canBeVerbal: true,
			type: .charm,
			light: "White",
			creator: "Unknown"
		)
	)
}
