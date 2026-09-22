import Core
import Detail
import Favorite
import Foundation
import Home

final class Injection: NSObject {
    private let persistence: PersistenceController

    init(persistence: PersistenceController = .shared) {
        self.persistence = persistence
    }

    private func provideRepository() -> GameRepositoryProtocol {
        let locale = LocaleDataSource.sharedInstance(persistence)
        let remote = RemoteDataSource.sharedInstance
        return GameRepository.sharedInstance(locale, remote)
    }

    func provideHome() -> HomeInteractor {
        HomeInteractor(repository: provideRepository())
    }

    func provideDetail() -> DetailInteractor {
        DetailInteractor(repository: provideRepository())
    }

    func provideFavorite() -> FavoriteInteractor {
        FavoriteInteractor(repository: provideRepository())
    }
}
