import About
import Favorite
import Home
import SwiftUI

struct ContentView: View {
    @ObservedObject var homePresenter: HomePresenter
    @ObservedObject var favoritePresenter: FavoritePresenter
    @ObservedObject var profileStore: ProfileStore

    var body: some View {
        TabView {
            HomeView(presenter: homePresenter)
                .tabItem {
                    Label("Games", systemImage: "gamecontroller")
                }

            FavoriteView(presenter: favoritePresenter)
                .tabItem {
                    Label("Favorit", systemImage: "heart")
                }

            AboutView(profileStore: profileStore)
                .tabItem {
                    Label("About", systemImage: "person")
                }
        }
    }
}
