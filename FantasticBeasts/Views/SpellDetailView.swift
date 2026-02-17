import SwiftUI

struct SpellDetailView: View {
	let spell: Spell

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {
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
