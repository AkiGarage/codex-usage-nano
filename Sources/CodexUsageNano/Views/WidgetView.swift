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
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(.primary.opacity(0.08), lineWidth: 1)
        )
        .overlay(alignment: .topTrailing) {
            if let opacityPercent = store.opacityHUDPercent {
                Text("OP \(opacityPercent)%")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(opacityColor)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 4)
                    .background {
                        Capsule()
                            .fill(opacityColor.opacity(0.16))
                            .background(.thinMaterial, in: Capsule())
                    }
                    .overlay(
                        Capsule()
                            .stroke(opacityColor.opacity(0.45), lineWidth: 1)
                    )
                    .padding(8)
            }
        }
    }

    private func layoutScale(for size: CGSize) -> CGFloat {
        min(max(min(size.width / baseWidth, size.height / baseHeight), 0.5), 1.25)
    }
}
