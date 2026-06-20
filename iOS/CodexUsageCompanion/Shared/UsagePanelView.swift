import SwiftUI

struct UsagePanelView: View {
    let snapshot: UsageSnapshot
    var compact = false

    var body: some View {
        VStack(alignment: .leading, spacing: compact ? 10 : 18) {
            UsageLimitRow(limit: snapshot.session, compact: compact)
            UsageLimitRow(limit: snapshot.weekly, compact: compact)
        }
        .padding(compact ? 12 : 18)
        .background(Color.codexPanel, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(.black.opacity(0.08), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 10, y: 4)
    }
}

struct UsageLimitRow: View {
    let limit: UsageLimit
    var compact = false

    var body: some View {
        VStack(alignment: .leading, spacing: compact ? 5 : 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(limit.title)
                    .font((compact ? Font.subheadline : Font.title3).weight(.bold))
                Spacer()
                Text("\(limit.remainingPercent)% left")
                    .font((compact ? Font.caption : Font.title3).weight(.medium))
            }

            UsageBar(limit: limit)
                .frame(height: compact ? 7 : 10)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(limit.detailText)
                    if !compact {
                        Text(limit.remainingLabel)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(limit.resetText)
                    if !limit.projectionText.isEmpty {
                        Text(limit.projectionText)
                    }
                }
            }
            .font(compact ? .caption2 : .subheadline)
            .foregroundStyle(.primary.opacity(0.86))
        }
    }
}

struct UsageBar: View {
    let limit: UsageLimit

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let progressWidth = max(0, min(width, width * CGFloat(limit.remainingPercent) / 100))
            let markerX = max(0, min(width, width * CGFloat(limit.markerPercent) / 100))

            ZStack(alignment: .leading) {
                Capsule().fill(.black.opacity(0.08))
                Capsule()
                    .fill(limit.state.color)
                    .frame(width: progressWidth)
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 2)
                    .offset(x: markerX)
            }
        }
        .clipShape(Capsule())
    }
}

extension Color {
    static let codexPanel = Color(.secondarySystemGroupedBackground)
    static let codexAppBackground = Color(.systemGroupedBackground)
}

#Preview {
    UsagePanelView(snapshot: .preview)
        .padding()
}
