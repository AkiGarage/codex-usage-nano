import SwiftUI

enum EdgeTabPresentationMode: Equatable {
    case collapsed
    case expanded
    case dragging
}

enum EdgeTabPresentation {
    static let collapsedSize = CGSize(width: 52, height: 16)
    static let expandedSize = CGSize(width: 52, height: 30)

    static func size(for mode: EdgeTabPresentationMode) -> CGSize {
        switch mode {
        case .expanded:
            expandedSize
        case .collapsed, .dragging:
            collapsedSize
        }
    }
}

@MainActor
final class EdgeTabPresentationState: ObservableObject {
    @Published var mode: EdgeTabPresentationMode = .collapsed
}

struct EdgeTabView: View {
    @ObservedObject var store: UsageStore
    @ObservedObject var presentation: EdgeTabPresentationState
    private let opacityColor = Color(red: 0.08, green: 0.64, blue: 0.86)

    var body: some View {
        Group {
            if isExpanded {
                expandedLabel
            } else {
                collapsedSignal
            }
        }
        .frame(width: size.width, height: size.height)
        .background {
            Capsule()
                .fill(isExpanded && isShowingOpacity ? opacityColor.opacity(0.18) : Color.clear)
                .background(.regularMaterial, in: Capsule())
        }
        .overlay(
            Capsule()
                .stroke(strokeColor, lineWidth: 1)
        )
        .accessibilityLabel(accessibilityText)
    }

    private var expandedLabel: some View {
        Text("\(displayPercent)%")
            .font(.system(size: 18, weight: .bold, design: .rounded))
            .monospacedDigit()
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .allowsTightening(true)
            .foregroundStyle(expandedTextColor)
            .padding(.horizontal, 3)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var collapsedSignal: some View {
        VStack(spacing: 2) {
            EdgeTabUsageBar(limit: store.snapshot.session)
            EdgeTabUsageBar(limit: store.snapshot.weekly)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
    }

    private var strokeColor: Color {
        if isExpanded, isShowingOpacity {
            return opacityColor.opacity(0.55)
        }
        return .primary.opacity(0.10)
    }

    private var size: CGSize {
        EdgeTabPresentation.size(for: presentation.mode)
    }

    private var isExpanded: Bool {
        presentation.mode == .expanded
    }

    private var isShowingOpacity: Bool {
        store.opacityHUDPercent != nil
    }

    private var displayPercent: Int {
        store.opacityHUDPercent ?? Int(store.snapshot.session.clampedLeftPercent.rounded())
    }

    private var expandedTextColor: Color {
        if isShowingOpacity {
            return opacityColor
        }
        return .black
    }

    private var accessibilityText: String {
        let session = Int(store.snapshot.session.clampedLeftPercent.rounded())
        let weekly = Int(store.snapshot.weekly.clampedLeftPercent.rounded())
        return "Codex usage tab, session \(session)% left, weekly \(weekly)% left"
    }
}

private struct EdgeTabUsageBar: View {
    let limit: UsageLimit

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.secondary.opacity(0.24))
                Capsule()
                    .fill(color)
                    .frame(width: fillWidth(in: proxy.size.width))
            }
        }
        .frame(height: 4)
    }

    private var color: Color {
        switch limit.tone {
        case .healthy:
            return Color(red: 0.12, green: 0.62, blue: 0.78)
        case .warning:
            return Color(red: 0.92, green: 0.58, blue: 0.05)
        case .critical:
            return Color(red: 0.86, green: 0.12, blue: 0.10)
        }
    }

    private func fillWidth(in width: CGFloat) -> CGFloat {
        let remainingWidth = width * limit.clampedLeftPercent / 100
        if limit.clampedLeftPercent <= 0 {
            return 4
        }
        return max(4, remainingWidth)
    }
}
