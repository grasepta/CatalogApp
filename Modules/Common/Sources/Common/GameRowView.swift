import Core
import Kingfisher
import SwiftUI

public struct GameRowView: View {
    let game: GameModel

    public init(game: GameModel) {
        self.game = game
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            KFImage(URL(string: game.backgroundImage ?? ""))
                .placeholder {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.gray.opacity(0.3))
                }
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipped()
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(game.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text("Rilis: \(GameDateFormatter.displayText(from: game.released))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    Text(String(format: "%.1f", game.rating))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.top, 2)
        }
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(rowAccessibilityLabel)
        .accessibilityHint("Ketuk untuk melihat detail game")
    }

    private var rowAccessibilityLabel: String {
        let rating = String(format: "%.1f", game.rating)
        let released = GameDateFormatter.displayText(from: game.released)
        return "\(game.name), peringkat \(rating), rilis \(released)"
    }
}
