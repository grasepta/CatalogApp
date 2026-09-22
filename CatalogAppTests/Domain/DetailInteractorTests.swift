import Core
import Detail
import XCTest

@MainActor
final class DetailInteractorTests: XCTestCase {
    private var repository: MockGameRepository!
    private var sut: DetailInteractor!

    override func setUp() {
        super.setUp()
        repository = MockGameRepository()
        sut = DetailInteractor(repository: repository)
    }

    override func tearDown() {
        sut = nil
        repository = nil
        super.tearDown()
    }

    func testGetGameDetailForwardsIDAndReturnsModel() throws {
        let detail = GameDetailModel.sample
        repository.gameDetailResult = .success(detail)

        let result = try PublisherTestHelper.awaitValue(sut.execute(request: detail.id))

        XCTAssertEqual(repository.lastGameID, detail.id)
        XCTAssertEqual(result, detail)
    }

    func testGetGameDetailPropagatesError() {
        repository.gameDetailResult = .failure(APIError.invalidResponse)

        XCTAssertThrowsError(try PublisherTestHelper.awaitValue(sut.execute(request: 1)))
    }

    func testAddFavoriteForwardsGame() throws {
        let game = GameModel.sample
        repository.addFavoriteResult = .success(true)

        let result = try PublisherTestHelper.awaitValue(sut.addFavorite(game))

        XCTAssertEqual(repository.lastFavoriteGame, game)
        XCTAssertTrue(result)
    }

    func testRemoveFavoriteForwardsID() throws {
        repository.removeFavoriteResult = .success(true)

        let result = try PublisherTestHelper.awaitValue(sut.removeFavorite(id: 3498))

        XCTAssertEqual(repository.lastGameID, 3498)
        XCTAssertTrue(result)
    }

    func testIsFavoriteForwardsID() throws {
        repository.isFavoriteResult = .success(true)

        let result = try PublisherTestHelper.awaitValue(sut.isFavorite(id: 3498))

        XCTAssertEqual(repository.lastGameID, 3498)
        XCTAssertTrue(result)
    }

    func testFavoriteOperationsPropagateError() {
        repository.addFavoriteResult = .failure(APIError.invalidResponse)
        repository.removeFavoriteResult = .failure(APIError.invalidResponse)
        repository.isFavoriteResult = .failure(APIError.invalidResponse)

        XCTAssertThrowsError(try PublisherTestHelper.awaitValue(sut.addFavorite(.sample)))
        XCTAssertThrowsError(try PublisherTestHelper.awaitValue(sut.removeFavorite(id: 1)))
        XCTAssertThrowsError(try PublisherTestHelper.awaitValue(sut.isFavorite(id: 1)))
    }
}
