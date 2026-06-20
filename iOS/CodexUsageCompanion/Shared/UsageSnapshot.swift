import Foundation
import SwiftUI

struct UsageSnapshot: Codable, Hashable {
    let updatedAt: Date
    let session: UsageLimit
    let weekly: UsageLimit

    var updatedText: String {
        let seconds = max(0, Int(Date().timeIntervalSince(updatedAt)))
        if seconds < 10 {
            return "Updated just now"
        }
        let minutes = max(1, seconds / 60)
        return "Updated \(minutes)m ago"
    }

    func refreshed() -> UsageSnapshot {
        UsageSnapshot(updatedAt: Date(), session: session, weekly: weekly)
    }

    static let preview = UsageSnapshot(
        updatedAt: Date(),
        session: UsageLimit(
            title: "Session",
            remainingPercent: 37,
            detailText: "On pace",
            resetText: "Resets in 1h 15m",
            projectionText: "Projected empty in 2h 11m",
            markerPercent: 25
        ),
        weekly: UsageLimit(
            title: "Weekly",
            remainingPercent: 77,
            detailText: "8% in deficit",
            resetText: "Resets in 5d 23h",
            projectionText: "Runs out in 3d 11h",
            markerPercent: 85
        )
    )

    static let demoSnapshots = [
        UsageSnapshot(
            updatedAt: Date(),
            session: UsageLimit(
                title: "Session",
                remainingPercent: 86,
                detailText: "3% in deficit",
                resetText: "Resets in 4h 28m",
                projectionText: "Projected empty in 3h 17m",
                markerPercent: 89
            ),
            weekly: UsageLimit(
                title: "Weekly",
                remainingPercent: 85,
                detailText: "2% in deficit",
                resetText: "Resets in 6d 2h",
                projectionText: "Runs out in 5d 2h",
                markerPercent: 87
            )
        ),
        UsageSnapshot(
            updatedAt: Date(),
            session: UsageLimit(
                title: "Session",
                remainingPercent: 29,
                detailText: "On pace",
                resetText: "Resets in 39m",
                projectionText: "Projected empty in 1h 46m",
                markerPercent: 25
            ),
            weekly: UsageLimit(
                title: "Weekly",
                remainingPercent: 76,
                detailText: "9% in deficit",
                resetText: "Resets in 5d 22h",
                projectionText: "Runs out in 3d 8h",
                markerPercent: 85
            )
        ),
        UsageSnapshot(
            updatedAt: Date(),
            session: UsageLimit(
                title: "Session",
                remainingPercent: 14,
                detailText: "On pace",
                resetText: "Resets in 5m",
                projectionText: "Projected empty in 47m",
                markerPercent: 20
            ),
            weekly: UsageLimit(
                title: "Weekly",
                remainingPercent: 73,
                detailText: "11% in deficit",
                resetText: "Resets in 5d 21h",
                projectionText: "Runs out in 2d 22h",
                markerPercent: 84
            )
        )
    ]
}

struct UsageLimit: Codable, Hashable, Identifiable {
    var id: String { title }

    let title: String
    let remainingPercent: Int
    let detailText: String
    let resetText: String
    let projectionText: String
    let markerPercent: Int

    var remainingLabel: String {
        "\(remainingPercent)% left"
    }

    var state: UsageState {
        if remainingPercent <= 15 {
            return .critical
        }
        if remainingPercent <= 30 {
            return .warning
        }
        return .normal
    }
}

enum UsageState: String, Codable, Hashable {
    case normal
    case warning
    case critical
    case stale

    var color: Color {
        switch self {
        case .normal:
            Color(red: 0.23, green: 0.71, blue: 0.82)
        case .warning:
            Color(red: 1.00, green: 0.75, blue: 0.18)
        case .critical:
            Color(red: 0.98, green: 0.18, blue: 0.18)
        case .stale:
            Color.gray.opacity(0.55)
        }
    }
}
