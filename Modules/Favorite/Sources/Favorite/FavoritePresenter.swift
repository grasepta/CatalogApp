import Combine
import Core
import SwiftUI

public final class FavoritePresenter: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let router: FavoriteRouter
    private let favoriteUseCase: FavoriteInteractor

    @Published public var favorites: [GameModel] = []
    @Published public var errorMessage = ""
    @Published public var isLoading = false
    @Published public var isError = false

    public init(favoriteUseCase: FavoriteInteractor, makeDetail: @escaping (Int) -> AnyView) {
        self.favoriteUseCase = favoriteUseCase
        self.router = FavoriteRouter(makeDetail: makeDetail)
    }

    public func getFavorites() {
        isLoading = true
        isError = false
        errorMessage = ""

        favoriteUseCase.execute(request: ())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isError = true
                    self.isLoading = false
                case .finished:
                    self.isLoading = false
                }
            }, receiveValue: { [weak self] favorites in
                self?.favorites = favorites
            })
            .store(in: &cancellables)
    }

    public func removeFavorite(id: Int) {
        favoriteUseCase.removeFavorite(id: id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
                self?.getFavorites()
            })
            .store(in: &cancellables)
    }

    public func makeDetailView(for gameID: Int) -> AnyView {
        router.makeDetailView(for: gameID)
    }
}
