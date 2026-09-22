import Combine
import Core
import Foundation

public final class DetailPresenter: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let detailUseCase: DetailInteractor
    private let gameID: Int

    @Published public var game: GameDetailModel?
    @Published public var errorMessage = ""
    @Published public var isLoading = false
    @Published public var isError = false
    @Published public var isFavorite = false

    public init(gameID: Int, detailUseCase: DetailInteractor) {
        self.gameID = gameID
        self.detailUseCase = detailUseCase
    }

    public func getGameDetail() {
        isLoading = true
        isError = false
        errorMessage = ""
        checkFavorite()

        detailUseCase.execute(request: gameID)
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
            }, receiveValue: { [weak self] game in
                self?.game = game
            })
            .store(in: &cancellables)
    }

    public func toggleFavorite() {
        guard let game else { return }

        let publisher = isFavorite
            ? detailUseCase.removeFavorite(id: game.id)
            : detailUseCase.addFavorite(game.asGameModel)

        publisher
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
                self?.checkFavorite()
            })
            .store(in: &cancellables)
    }

    private func checkFavorite() {
        detailUseCase.isFavorite(id: gameID)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] isFavorite in
                self?.isFavorite = isFavorite
            })
            .store(in: &cancellables)
    }
}
