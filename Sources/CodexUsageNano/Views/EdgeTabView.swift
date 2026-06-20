import SwiftUI

struct EdgeTabView: View {
    @ObservedObject var store: UsageStore
    private let opacityColor = Color(red: 0.08, green: 0.64, blue: 0.86)

    var body: some View {
        HStack(spacing: 4) {
            Text(labelPrefix)
                .font(.system(size: isShowingOpacity ? 11 : 12, weight: .bold, design: isShowingOpacity ? .rounded : .default))
            Text("\(displayPercent)%")
                .font(.system(size: 12, weight: isShowingOpacity ? .semibold : .regular, design: isShowingOpacity ? .rounded : .default))
                .monospacedDigit()
        }
        .foregroundStyle(isShowingOpacity ? opacityColor : .primary)
        .frame(width: 76, height: 30)
        .background {
            Capsule()
                .fill(isShowingOpacity ? opacityColor.opacity(0.18) : Color.clear)
                .background(.regularMaterial, in: Capsule())
        }
        .overlay(
            Capsule()
                .stroke(isShowingOpacity ? opacityColor.opacity(0.55) : .primary.opacity(0.10), lineWidth: 1)
        )
    }

    private var isShowingOpacity: Bool {
        store.opacityHUDPercent != nil
    }

    private var labelPrefix: String {
        isShowingOpacity ? "OP" : "C"
    }

    private var displayPercent: Int {
        store.opacityHUDPercent ?? Int(store.snapshot.session.clampedLeftPercent.rounded())
    }
}
