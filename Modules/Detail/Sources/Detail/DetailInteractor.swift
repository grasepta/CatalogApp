import Combine
import Core
import Foundation

public final class DetailInteractor: UseCase {
    public typealias Request = Int
    public typealias Response = GameDetailModel

    private let repository: GameRepositoryProtocol

    public init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(request: Int) -> AnyPublisher<GameDetailModel, Error> {
        repository.getGameDetail(id: request)
    }

    public func addFavorite(_ game: GameModel) -> AnyPublisher<Bool, Error> {
        repository.addFavorite(game)
    }

    public func removeFavorite(id: Int) -> AnyPublisher<Bool, Error> {
        repository.removeFavorite(id: id)
    }

    public func isFavorite(id: Int) -> AnyPublisher<Bool, Error> {
        repository.isFavorite(id: id)
    }
}
