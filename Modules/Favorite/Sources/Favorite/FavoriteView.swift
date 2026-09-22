import Common
import SwiftUI

public struct FavoriteView: View {
    @ObservedObject var presenter: FavoritePresenter

    public init(presenter: FavoritePresenter) {
        self.presenter = presenter
    }

    public var body: some View {
        NavigationStack {
            Group {
                if presenter.isLoading && presenter.favorites.isEmpty {
                    ProgressView()
                } else if presenter.isError && presenter.favorites.isEmpty {
                    ErrorStateView(message: presenter.errorMessage) {
                        presenter.getFavorites()
                    }
                } else if presenter.favorites.isEmpty {
                    ContentUnavailableView(
                        "Belum ada game favorit",
                        systemImage: "heart",
                        description: Text("Tambahkan game ke favorit dari halaman detail.")
                    )
                } else {
                    List {
                        ForEach(presenter.favorites) { game in
                            NavigationLink(value: game.id) {
                                GameRowView(game: game)
                            }
                        }
                        .onDelete(perform: deleteFavorites)
                    }
                    .listStyle(.plain)
                    .toolbar {
                        EditButton()
                    }
                }
            }
            .navigationTitle("Favorit")
            .navigationDestination(for: Int.self) { gameID in
                presenter.makeDetailView(for: gameID)
            }
            .onAppear {
                presenter.getFavorites()
            }
        }
    }

    private func deleteFavorites(at offsets: IndexSet) {
        let ids = offsets.map { presenter.favorites[$0].id }
        ids.forEach { presenter.removeFavorite(id: $0) }
    }
}
