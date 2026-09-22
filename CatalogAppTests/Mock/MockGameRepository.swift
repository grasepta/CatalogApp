import Combine
import Core
import Foundation

final class MockGameRepository: GameRepositoryProtocol {
    var gamesPageResult: Result<GamesPage, Error> = .success(GamesPage(games: [], hasNextPage: false))
    var gameDetailResult: Result<GameDetailModel, Error> = .failure(APIError.invalidResponse)
    var favoritesResult: Result<[GameModel], Error> = .success([])
    var addFavoriteResult: Result<Bool, Error> = .success(true)
    var removeFavoriteResult: Result<Bool, Error> = .success(true)
    var isFavoriteResult: Result<Bool, Error> = .success(false)

    private(set) var lastQuery: String?
    private(set) var lastPage: Int?
    private(set) var lastGameID: Int?
    private(set) var lastFavoriteGame: GameModel?

    func getGames(query: String, page: Int) -> AnyPublisher<GamesPage, Error> {
        lastQuery = query
        lastPage = page
        return resultPublisher(gamesPageResult)
    }

    func getGameDetail(id: Int) -> AnyPublisher<GameDetailModel, Error> {
        lastGameID = id
        return resultPublisher(gameDetailResult)
    }

    func getFavorites() -> AnyPublisher<[GameModel], Error> {
        resultPublisher(favoritesResult)
    }

    func addFavorite(_ game: GameModel) -> AnyPublisher<Bool, Error> {
        lastFavoriteGame = game
        return resultPublisher(addFavoriteResult)
    }

    func removeFavorite(id: Int) -> AnyPublisher<Bool, Error> {
        lastGameID = id
        return resultPublisher(removeFavoriteResult)
    }

    func isFavorite(id: Int) -> AnyPublisher<Bool, Error> {
        lastGameID = id
        return resultPublisher(isFavoriteResult)
    }

    private func resultPublisher<T>(_ result: Result<T, Error>) -> AnyPublisher<T, Error> {
        result.publisher.eraseToAnyPublisher()
    }
}
