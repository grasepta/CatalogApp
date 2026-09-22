import Combine
import Core
import Foundation

public struct HomeInteractor: UseCase {
    public typealias Request = GamesQuery
    public typealias Response = GamesPage

    private let repository: GameRepositoryProtocol

    public init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(request: GamesQuery) -> AnyPublisher<GamesPage, Error> {
        repository.getGames(query: request.query, page: request.page)
    }
}
