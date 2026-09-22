import SwiftUI

public struct ErrorStateView: View {
    let message: String
    let retryAction: () -> Void

    public init(message: String, retryAction: @escaping () -> Void) {
        self.message = message
        self.retryAction = retryAction
    }

    public var body: some View {
        ContentUnavailableView {
            Label("Gagal Memuat Data", systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button("Coba lagi", action: retryAction)
                .buttonStyle(.borderedProminent)
                .accessibilityHint("Ketuk untuk memuat ulang data")
        }
        .padding(16)
    }
}
