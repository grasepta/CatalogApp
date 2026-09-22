import Common
import Core
import Kingfisher
import SwiftUI

public struct DetailView: View {
    @StateObject private var presenter: DetailPresenter

    public init(presenter: DetailPresenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }

    public var body: some View {
        Group {
            if presenter.isLoading && presenter.game == nil {
                ProgressView()
            } else if presenter.isError && presenter.game == nil {
                ErrorStateView(message: presenter.errorMessage) {
                    presenter.getGameDetail()
                }
            } else if let game = presenter.game {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        KFImage(URL(string: game.backgroundImage ?? ""))
                            .placeholder {
                                Rectangle()
                                    .fill(.gray.opacity(0.3))
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(height: 220)
                            .frame(maxWidth: .infinity)
                            .clipped()

                        VStack(alignment: .leading, spacing: 8) {
                            Text(game.name)
                                .font(.title2)
                                .bold()

                            chipSection(title: "Genre", items: game.genres)
                            chipSection(title: "Platform", items: game.platforms)

                            Text("Rilis: \(GameDateFormatter.displayText(from: game.released))")
                                .foregroundStyle(.secondary)

                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                                Text(String(format: "Peringkat: %.1f", game.rating))
                                    .foregroundStyle(.secondary)
                            }

                            Text("Deskripsi")
                                .font(.headline)
                                .padding(.top, 8)
                            Text(game.descriptionText)
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationTitle("Detail Game")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if presenter.game != nil {
                    Button(action: presenter.toggleFavorite) {
                        Image(systemName: presenter.isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(.red)
                    }
                    .accessibilityLabel(presenter.isFavorite ? "Hapus dari favorit" : "Tambah ke favorit")
                    .accessibilityHint(
                        presenter.isFavorite
                            ? "Ketuk untuk menghapus game dari favorit"
                            : "Ketuk untuk menambahkan game ke favorit"
                    )
                }
            }
        }
        .task {
            presenter.getGameDetail()
        }
    }

    @ViewBuilder
    private func chipSection(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            if items.isEmpty {
                Text("-")
                    .foregroundStyle(.secondary)
            } else {
                FlowLayout(spacing: 8) {
                    ForEach(items, id: \.self) { item in
                        InfoChip(title: item)
                    }
                }
            }
        }
        .padding(.top, 4)
    }
}
