import Combine
import Core
import SwiftUI

public final class HomePresenter: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private var gamesCancellable: AnyCancellable?
    private let router: HomeRouter
    private let homeUseCase: HomeInteractor

    @Published public var games: [GameModel] = []
    @Published public var searchText = ""
    @Published public var errorMessage = ""
    @Published public var isLoading = false
    @Published public var isLoadingMore = false
    @Published public var isError = false
    @Published public private(set) var hasNextPage = false

    private var currentPage = 1

    public init(homeUseCase: HomeInteractor, makeDetail: @escaping (Int) -> AnyView) {
        self.homeUseCase = homeUseCase
        self.router = HomeRouter(makeDetail: makeDetail)
        bindSearch()
        getGames(query: "")
    }

    public func getGames(query: String) {
        currentPage = 1
        hasNextPage = false
        isLoading = true
        isLoadingMore = false
        isError = false
        errorMessage = ""

        gamesCancellable = homeUseCase.execute(request: GamesQuery(query: query, page: 1))
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isError = true
                    self.isLoading = false
                    self.games = []
                    self.hasNextPage = false
                case .finished:
                    self.isLoading = false
                }
            }, receiveValue: { [weak self] page in
                self?.games = page.games
                self?.hasNextPage = page.hasNextPage
                self?.currentPage = 1
            })
    }

    public func loadMore() {
        guard !isLoading, !isLoadingMore, hasNextPage, !games.isEmpty else {
            return
        }

        isLoadingMore = true
        let nextPage = currentPage + 1
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        gamesCancellable = homeUseCase.execute(request: GamesQuery(query: query, page: nextPage))
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                self.isLoadingMore = false
                if case .failure = completion {
                    return
                }
            }, receiveValue: { [weak self] page in
                guard let self else { return }
                self.games.append(contentsOf: page.games)
                self.hasNextPage = page.hasNextPage
                self.currentPage = nextPage
            })
    }

    public func makeDetailView(for gameID: Int) -> AnyView {
        router.makeDetailView(for: gameID)
    }

    private func bindSearch() {
        $searchText
            .dropFirst()
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .removeDuplicates()
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.getGames(query: query)
            }
            .store(in: &cancellables)
    }
}
