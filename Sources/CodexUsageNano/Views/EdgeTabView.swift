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
            LiquidGlassSurface(
                shape: Capsule(),
                tint: tabTint,
                intensity: isExpanded ? .tabExpanded : .tabCollapsed
            )
        }
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
            .shadow(color: .white.opacity(0.28), radius: 0.5, x: 0, y: 0.5)
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
        return .primary.opacity(0.94)
    }

    private var tabTint: Color {
        if isShowingOpacity {
            return opacityColor
        }
        return color(for: store.snapshot.session.tone)
    }

    private var accessibilityText: String {
        let session = Int(store.snapshot.session.clampedLeftPercent.rounded())
        let weekly = Int(store.snapshot.weekly.clampedLeftPercent.rounded())
        return "Codex usage tab, session \(session)% left, weekly \(weekly)% left"
    }

    private func color(for tone: UsageTone) -> Color {
        switch tone {
        case .healthy:
            return Color(red: 0.20, green: 0.68, blue: 0.86)
        case .warning:
            return Color(red: 0.94, green: 0.62, blue: 0.10)
        case .critical:
            return Color(red: 0.90, green: 0.20, blue: 0.18)
        }
    }
}

private struct EdgeTabUsageBar: View {
    let limit: UsageLimit

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let filledWidth = EdgeTabUsageBarLayout.fillWidth(
                for: limit.clampedLeftPercent,
                in: width
            )
            ZStack(alignment: .leading) {
                LiquidGlassSurface(
                    shape: Capsule(),
                    tint: .white,
                    intensity: .barTrack
                )
                if filledWidth > 0 {
                    Capsule()
                        .fill(color.opacity(0.92))
                        .frame(width: filledWidth)
                        .shadow(color: color.opacity(0.10), radius: 0.6, x: 0, y: 0)
                        .overlay(alignment: .top) {
                            Capsule()
                                .fill(.white.opacity(0.10))
                                .frame(height: 1)
                        }
                }
                Capsule()
                    .strokeBorder(.white.opacity(0.05), lineWidth: 0.4)
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
}

enum EdgeTabUsageBarLayout {
    static let minimumVisibleFillWidth: CGFloat = 4

    static func fillWidth(for leftPercent: Double, in width: CGFloat) -> CGFloat {
        let clampedPercent = min(max(leftPercent, 0), 100)
        guard clampedPercent > 0, width > 0 else {
            return 0
        }

        let remainingWidth = width * CGFloat(clampedPercent / 100)
        return min(width, max(minimumVisibleFillWidth, remainingWidth))
    }
}
