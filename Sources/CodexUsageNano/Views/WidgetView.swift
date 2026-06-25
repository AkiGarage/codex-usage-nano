import SwiftUI

struct WidgetView: View {
    @ObservedObject var store: UsageStore
    private let baseWidth: CGFloat = 360
    private let baseHeight: CGFloat = 190
    private let opacityColor = Color(red: 0.08, green: 0.64, blue: 0.86)

    var body: some View {
        GeometryReader { proxy in
            let scale = layoutScale(for: proxy.size)

            VStack(alignment: .leading, spacing: 10 * scale) {
                UsageLimitRow(limit: store.snapshot.session, scale: scale)
                UsageLimitRow(limit: store.snapshot.weekly, scale: scale)

                if let errorMessage = store.errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 10 * scale, weight: .regular))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal, 16 * scale)
            .padding(.vertical, 10 * scale)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(minWidth: 180, idealWidth: baseWidth, maxWidth: .infinity, minHeight: 103, idealHeight: baseHeight, maxHeight: .infinity, alignment: .topLeading)
        .background {
            LiquidGlassSurface(
                shape: RoundedRectangle(cornerRadius: 17, style: .continuous),
                tint: .white,
                intensity: .panel
            )
        }
        .overlay(alignment: .topTrailing) {
            if let opacityPercent = store.opacityHUDPercent {
                Text("OP \(opacityPercent)%")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(opacityColor)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background {
                        LiquidGlassSurface(
                            shape: Capsule(),
                            tint: opacityColor,
                            intensity: .hud
                        )
                    }
                    .padding(.top, 5)
                    .padding(.trailing, 6)
            }
        }
    }

    private func layoutScale(for size: CGSize) -> CGFloat {
        min(max(min(size.width / baseWidth, size.height / baseHeight), 0.5), 1.25)
    }
}
