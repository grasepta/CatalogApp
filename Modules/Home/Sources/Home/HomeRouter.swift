import SwiftUI

public final class HomeRouter {
    private let makeDetail: (Int) -> AnyView

    public init(makeDetail: @escaping (Int) -> AnyView) {
        self.makeDetail = makeDetail
    }

    public func makeDetailView(for gameID: Int) -> AnyView {
        makeDetail(gameID)
    }
}
