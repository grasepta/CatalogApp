import Combine
import Core
import Foundation

public final class FavoriteInteractor: UseCase {
    public typealias Request = Void
    public typealias Response = [GameModel]

    private let repository: GameRepositoryProtocol

    public init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(request: Void) -> AnyPublisher<[GameModel], Error> {
        repository.getFavorites()
    }

    public func removeFavorite(id: Int) -> AnyPublisher<Bool, Error> {
        repository.removeFavorite(id: id)
    }
}
