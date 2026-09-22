import SwiftUI

public struct InfoChip: View {
    let title: String

    public init(title: String) {
        self.title = title
    }

    public var body: some View {
        Text(title)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.accentColor.opacity(0.12))
            .foregroundStyle(Color.accentColor)
            .clipShape(Capsule())
    }
}

public struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    public init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        arrange(proposal: proposal, subviews: subviews).size
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for index in subviews.indices {
            subviews[index].place(
                at: CGPoint(
                    x: bounds.minX + result.positions[index].x,
                    y: bounds.minY + result.positions[index].y
                ),
                proposal: .unspecified
            )
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var originX: CGFloat = 0
        var originY: CGFloat = 0
        var rowHeight: CGFloat = 0
        var contentWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if originX + size.width > maxWidth, originX > 0 {
                originX = 0
                originY += rowHeight + spacing
                rowHeight = 0
            }

            positions.append(CGPoint(x: originX, y: originY))
            rowHeight = max(rowHeight, size.height)
            originX += size.width + spacing
            contentWidth = max(contentWidth, originX - spacing)
        }

        return (positions, CGSize(width: contentWidth, height: originY + rowHeight))
    }
}
