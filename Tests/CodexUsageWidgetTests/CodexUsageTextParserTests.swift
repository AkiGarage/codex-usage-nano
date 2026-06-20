import XCTest
@testable import CodexUsageWidget

final class CodexUsageTextParserTests: XCTestCase {
    func testParsesCodexBarJSONLimitsAndWeeklyPace() throws {
        let json = """
        [
          {
            "provider": "codex",
            "usage": {
              "primary": {
                "usedPercent": 0,
                "windowMinutes": 300
              },
              "secondary": {
                "usedPercent": 13,
                "windowMinutes": 10080,
                "resetsAt": "2026-06-11T03:50:05Z"
              }
            }
          }
        ]
        """
        let now = ISO8601DateFormatter().date(from: "2026-06-05T01:00:05Z")!

        let snapshot = try CodexUsageTextParser.parseJSON(Data(json.utf8), now: now)

        XCTAssertEqual(snapshot.session.leftPercent, 100)
        XCTAssertEqual(snapshot.session.resetText, "Resets in 5h")
        XCTAssertNil(snapshot.session.detailText)
        XCTAssertNil(snapshot.session.projectionText)
        XCTAssertNil(snapshot.session.markerPercent)
        XCTAssertEqual(snapshot.weekly.leftPercent, 87)
        XCTAssertEqual(snapshot.weekly.resetText, "Resets in 6d 2h")
        XCTAssertEqual(snapshot.weekly.detailText, "On pace")
        XCTAssertEqual(snapshot.weekly.projectionText, "Runs out in 5d 21h")
        XCTAssertEqual(snapshot.weekly.markerPercent, 87)
    }

    func testJSONUsesResetDescriptionTimeWhenResetsAtIsMissing() throws {
        let json = """
        [
          {
            "provider": "codex",
            "usage": {
              "primary": {
                "resetDescription": "Resets 3:19 PM",
                "usedPercent": 77,
                "windowMinutes": 300
              },
              "secondary": {
                "resetDescription": "Resets Jun 11, 2026 12:50 PM",
                "usedPercent": 67,
                "windowMinutes": 10080,
                "resetsAt": "2026-06-11T03:50:43Z"
              }
            }
          }
        ]
        """
        let now = ISO8601DateFormatter().date(from: "2026-06-06T05:25:00Z")!
        let timeZone = TimeZone(secondsFromGMT: 9 * 60 * 60)!

        let snapshot = try CodexUsageTextParser.parseJSON(Data(json.utf8), now: now, timeZone: timeZone)

        XCTAssertEqual(snapshot.session.leftPercent, 23)
        XCTAssertEqual(snapshot.session.resetText, "Resets in 54m")
        XCTAssertEqual(snapshot.session.detailText, "On pace")
        XCTAssertEqual(snapshot.session.projectionText, "Projected empty in 1h 13m")
        XCTAssertEqual(snapshot.session.markerPercent, 18)
        XCTAssertEqual(snapshot.weekly.leftPercent, 33)
        XCTAssertEqual(snapshot.weekly.resetText, "Resets in 4d 22h")
    }

    func testParsesSessionAndWeeklyLimits() throws {
        let text = """
        == Codex (openai-web) ==
        Session: 94% left [===========-]
        Resets 5:50 PM
        Weekly: 99% left [===========-]
        Resets in 6d 23h
        Credits: 0 left
        """

        let snapshot = try CodexUsageTextParser.parse(text)

        XCTAssertEqual(snapshot.session.title, "Session")
        XCTAssertEqual(snapshot.session.leftPercent, 94)
        XCTAssertEqual(snapshot.session.resetText, "Resets 5:50 PM")
        XCTAssertEqual(snapshot.weekly.title, "Weekly")
        XCTAssertEqual(snapshot.weekly.leftPercent, 99)
        XCTAssertEqual(snapshot.weekly.resetText, "Resets in 6d 23h")
    }

    func testTextParserDoesNotApplyWeeklyResetToSession() throws {
        let text = """
        == Codex (openai-web) ==
        Session: 100% left [============]
        Weekly: 87% left [==========--]
        Pace: On pace | Expected 13% used | Runs out in 5d 21h
        Resets in 6d 2h
        Credits: 0 left
        """

        let snapshot = try CodexUsageTextParser.parse(text)

        XCTAssertEqual(snapshot.session.resetText, "Reset pending")
        XCTAssertNil(snapshot.session.detailText)
        XCTAssertEqual(snapshot.weekly.resetText, "Resets in 6d 2h")
        XCTAssertEqual(snapshot.weekly.detailText, "On pace")
        XCTAssertEqual(snapshot.weekly.projectionText, "Runs out in 5d 21h")
        XCTAssertEqual(snapshot.weekly.markerPercent, 87)
    }

    func testJSONDeficitProjectionAndMarker() throws {
        let json = """
        [
          {
            "provider": "codex",
            "usage": {
              "primary": {
                "usedPercent": 14,
                "windowMinutes": 300,
                "resetsAt": "2026-06-05T05:58:00Z"
              },
              "secondary": {
                "usedPercent": 14,
                "windowMinutes": 10080,
                "resetsAt": "2026-06-11T03:50:26Z"
              }
            }
          }
        ]
        """
        let now = ISO8601DateFormatter().date(from: "2026-06-05T01:31:00Z")!

        let snapshot = try CodexUsageTextParser.parseJSON(Data(json.utf8), now: now)

        XCTAssertEqual(snapshot.session.leftPercent, 86)
        XCTAssertEqual(snapshot.session.detailText, "3% in deficit")
        XCTAssertEqual(snapshot.session.projectionText, "Projected empty in 3h 22m")
        XCTAssertEqual(snapshot.session.markerPercent, 89)
    }

    func testUsageToneThresholds() {
        XCTAssertEqual(limit(31).tone, .healthy)
        XCTAssertEqual(limit(30).tone, .warning)
        XCTAssertEqual(limit(16).tone, .warning)
        XCTAssertEqual(limit(15).tone, .critical)
    }

    private func limit(_ leftPercent: Double) -> UsageLimit {
        UsageLimit(title: "Session", leftPercent: leftPercent, resetText: "Resets soon")
    }
}
