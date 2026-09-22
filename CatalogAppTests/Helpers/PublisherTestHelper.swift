import Combine
import XCTest

enum PublisherTestHelper {
    static func awaitValue<T>(
        _ publisher: AnyPublisher<T, Error>,
        timeout: TimeInterval = 1,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> T {
        let expectation = XCTestExpectation(description: "Wait for publisher")
        var output: T?
        var receivedError: Error?
        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            },
            receiveValue: { value in
                output = value
            }
        )

        let waiter = XCTWaiter()
        let result = waiter.wait(for: [expectation], timeout: timeout)
        _ = cancellable

        guard result == .completed else {
            XCTFail("Publisher timed out", file: file, line: line)
            throw APIErrorStub.timeout
        }

        if let receivedError {
            throw receivedError
        }

        guard let output else {
            XCTFail("Publisher finished without a value", file: file, line: line)
            throw APIErrorStub.missingValue
        }

        return output
    }
}

private enum APIErrorStub: Error {
    case timeout
    case missingValue
}
