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

				// Add more fields here as your model grows

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
	// Provide a lightweight preview using a mock Spell. Adjust initializer to your model.
	// Replace with a proper factory if available in your project.
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
