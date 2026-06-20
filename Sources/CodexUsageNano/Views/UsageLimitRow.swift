import SwiftUI

struct UsageLimitRow: View {
    let limit: UsageLimit
    let scale: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 8 * scale) {
            Text(limit.title)
                .font(.system(size: 16 * scale, weight: .bold))
                .foregroundStyle(.primary)
                .lineLimit(1)

            UsageBar(
                percent: limit.clampedLeftPercent,
                tone: limit.tone,
                markerPercent: limit.markerPercent,
                scale: scale
            )
                .frame(height: 8 * scale)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2 * scale) {
                    Text(limit.leftText)
                        .font(.system(size: 12 * scale, weight: .regular))
                        .lineLimit(1)
                    if let detailText = limit.detailText {
                        Text(detailText)
                            .font(.system(size: 11 * scale, weight: .regular))
                            .lineLimit(1)
                    }
                }

                Spacer(minLength: 12 * scale)

                VStack(alignment: .trailing, spacing: 2 * scale) {
                    Text(limit.resetText)
                        .font(.system(size: 12 * scale, weight: .regular))
                        .lineLimit(1)
                    if let projectionText = limit.projectionText {
                        Text(projectionText)
                            .font(.system(size: 11 * scale, weight: .regular))
                            .lineLimit(1)
                    }
                }
                .foregroundStyle(.secondary)
            }
        }
    }
}

private struct UsageBar: View {
    let percent: Double
    let tone: UsageTone
    let markerPercent: Double?
    let scale: CGFloat

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.secondary.opacity(0.12))
                Capsule()
                    .fill(fillColor)
                    .frame(width: width * percent / 100)
                tick(at: 0.20, width: width)
                tick(at: 0.50, width: width)
                if let markerPercent {
                    warningMarker(at: markerPercent, width: width)
                }
            }
        }
    }

    private var fillColor: Color {
        switch tone {
        case .healthy:
            return Color(red: 0.28, green: 0.73, blue: 0.86)
        case .warning:
            return Color(red: 0.96, green: 0.72, blue: 0.18)
        case .critical:
            return Color(red: 0.95, green: 0.24, blue: 0.20)
        }
    }

    private func tick(at position: Double, width: Double) -> some View {
        Rectangle()
            .fill(.primary.opacity(0.34))
            .frame(width: max(1, scale), height: 5 * scale)
            .offset(x: width * position)
    }

    private func warningMarker(at percent: Double, width: Double) -> some View {
        Rectangle()
            .fill(Color(red: 0.95, green: 0.24, blue: 0.20))
            .frame(width: max(1, 2 * scale), height: 8 * scale)
            .offset(x: max(0, min(width - max(1, 2 * scale), width * percent / 100)))
    }
}
