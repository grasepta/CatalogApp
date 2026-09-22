import Common
import SwiftUI

public struct HomeView: View {
    @ObservedObject var presenter: HomePresenter

    public init(presenter: HomePresenter) {
        self.presenter = presenter
    }

    public var body: some View {
        NavigationStack {
            Group {
                if presenter.isLoading && presenter.games.isEmpty {
                    ProgressView()
                } else if presenter.isError && presenter.games.isEmpty {
                    ErrorStateView(message: presenter.errorMessage) {
                        presenter.getGames(
                            query: presenter.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                    }
                } else if presenter.games.isEmpty {
                    ContentUnavailableView(
                        "Tidak ada hasil",
                        systemImage: "magnifyingglass",
                        description: Text("Coba kata kunci lain untuk mencari game.")
                    )
                } else {
                    gameList
                }
            }
            .navigationTitle("Daftar Game")
            .navigationDestination(for: Int.self) { gameID in
                presenter.makeDetailView(for: gameID)
            }
            .searchable(text: $presenter.searchText, prompt: "Cari game…")
        }
    }

    private var gameList: some View {
        List {
            ForEach(presenter.games) { game in
                NavigationLink(value: game.id) {
                    GameRowView(game: game)
                }
                .onAppear {
                    if game.id == presenter.games.last?.id {
                        presenter.loadMore()
                    }
                }
            }

            if presenter.isLoadingMore {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}
