import Core
import Home
import XCTest

@MainActor
final class HomeInteractorTests: XCTestCase {
    private var repository: MockGameRepository!
    private var sut: HomeInteractor!

    override func setUp() {
        super.setUp()
        repository = MockGameRepository()
        sut = HomeInteractor(repository: repository)
    }

    override func tearDown() {
        sut = nil
        repository = nil
        super.tearDown()
    }

    func testGetGamesForwardsQueryAndPage() throws {
        let games = [GameModel.sample]
        repository.gamesPageResult = .success(GamesPage(games: games, hasNextPage: true))

        let page = try PublisherTestHelper.awaitValue(
            sut.execute(request: GamesQuery(query: "gta", page: 2))
        )

        XCTAssertEqual(repository.lastQuery, "gta")
        XCTAssertEqual(repository.lastPage, 2)
        XCTAssertEqual(page.games, games)
        XCTAssertTrue(page.hasNextPage)
    }

    func testGetGamesPropagatesError() {
        repository.gamesPageResult = .failure(APIError.invalidResponse)

        XCTAssertThrowsError(
            try PublisherTestHelper.awaitValue(sut.execute(request: GamesQuery(query: "", page: 1)))
        )
    }
}
