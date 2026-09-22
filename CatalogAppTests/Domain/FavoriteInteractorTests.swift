import Core
import Favorite
import XCTest

@MainActor
final class FavoriteInteractorTests: XCTestCase {
    private var repository: MockGameRepository!
    private var sut: FavoriteInteractor!

    override func setUp() {
        super.setUp()
        repository = MockGameRepository()
        sut = FavoriteInteractor(repository: repository)
    }

    override func tearDown() {
        sut = nil
        repository = nil
        super.tearDown()
    }

    func testGetFavoritesReturnsGames() throws {
        let games = [GameModel.sample]
        repository.favoritesResult = .success(games)

        let result = try PublisherTestHelper.awaitValue(sut.execute(request: ()))

        XCTAssertEqual(result, games)
    }

    func testGetFavoritesPropagatesError() {
        repository.favoritesResult = .failure(APIError.invalidResponse)

        XCTAssertThrowsError(try PublisherTestHelper.awaitValue(sut.execute(request: ())))
    }

    func testRemoveFavoriteForwardsID() throws {
        repository.removeFavoriteResult = .success(true)

        let result = try PublisherTestHelper.awaitValue(sut.removeFavorite(id: 3498))

        XCTAssertEqual(repository.lastGameID, 3498)
        XCTAssertTrue(result)
    }

    func testRemoveFavoritePropagatesError() {
        repository.removeFavoriteResult = .failure(APIError.invalidResponse)

        XCTAssertThrowsError(try PublisherTestHelper.awaitValue(sut.removeFavorite(id: 1)))
    }
}
