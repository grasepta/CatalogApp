import About
import Detail
import Favorite
import Home
import SwiftUI

@main
struct CatalogApp: App {
    @StateObject private var homePresenter: HomePresenter
    @StateObject private var favoritePresenter: FavoritePresenter
    @StateObject private var profileStore: ProfileStore

    init() {
        let injection = Injection()
        let makeDetail: (Int) -> AnyView = { gameID in
            AnyView(
                DetailView(
                    presenter: DetailPresenter(
                        gameID: gameID,
                        detailUseCase: injection.provideDetail()
                    )
                )
            )
        }

        _homePresenter = StateObject(
            wrappedValue: HomePresenter(
                homeUseCase: injection.provideHome(),
                makeDetail: makeDetail
            )
        )
        _favoritePresenter = StateObject(
            wrappedValue: FavoritePresenter(
                favoriteUseCase: injection.provideFavorite(),
                makeDetail: makeDetail
            )
        )
        _profileStore = StateObject(wrappedValue: ProfileStore())
    }

    var body: some Scene {
        WindowGroup {
            ContentView(
                homePresenter: homePresenter,
                favoritePresenter: favoritePresenter,
                profileStore: profileStore
            )
        }
    }
}
