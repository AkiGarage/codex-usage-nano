import AppKit
import XCTest
@testable import CodexUsageWidget

final class TabPositioningTests: XCTestCase {
    func testTabWindowLevelCanOccupyMenuBarArea() {
        XCTAssertEqual(TabPositioning.windowLevel, .statusBar)
        XCTAssertGreaterThan(TabPositioning.windowLevel.rawValue, NSWindow.Level.floating.rawValue)
    }

    func testPanelHugsTabWhenTabIsInMenuBarArea() {
        let visibleFrame = NSRect(x: 0, y: 0, width: 1470, height: 923)
        let panelSize = NSSize(width: 360, height: 190)
        let tabFrame = NSRect(x: 1350, y: 926, width: 76, height: 30)

        let origin = TabPositioning.panelOrigin(
            size: panelSize,
            anchor: tabFrame,
            visibleFrame: visibleFrame,
            screenFrame: NSRect(x: 0, y: 0, width: 1470, height: 956)
        )

        XCTAssertEqual(origin.x, 982)
        XCTAssertEqual(origin.y + panelSize.height, tabFrame.minY)
    }

    func testPanelKeepsCenteredPlacementAwayFromMenuBar() {
        let visibleFrame = NSRect(x: 0, y: 0, width: 1470, height: 923)
        let panelSize = NSSize(width: 360, height: 190)
        let tabFrame = NSRect(x: 1350, y: 400, width: 76, height: 30)

        let origin = TabPositioning.panelOrigin(
            size: panelSize,
            anchor: tabFrame,
            visibleFrame: visibleFrame,
            screenFrame: NSRect(x: 0, y: 0, width: 1470, height: 956)
        )

        XCTAssertEqual(origin.y, 320)
    }

    func testOpacityAdjustsContinuouslyAndClamps() {
        XCTAssertEqual(TabPositioning.adjustedOpacity(current: 0.5, scrollDeltaY: 25), 0.55)
        XCTAssertEqual(TabPositioning.adjustedOpacity(current: 0, scrollDeltaY: 25), 0.05)
        XCTAssertEqual(TabPositioning.adjustedOpacity(current: 0.5, scrollDeltaY: -1_000), 0)
        XCTAssertEqual(TabPositioning.adjustedOpacity(current: 0.5, scrollDeltaY: 1_000), 1)
    }

    func testOpacityPercentRoundsAndClamps() {
        XCTAssertEqual(TabPositioning.opacityPercent(for: 0), 0)
        XCTAssertEqual(TabPositioning.opacityPercent(for: 0.754), 75)
        XCTAssertEqual(TabPositioning.opacityPercent(for: 1.4), 100)
        XCTAssertEqual(TabPositioning.opacityPercent(for: -0.2), 0)
    }

    func testTabCanReachScreenTopAboveVisibleFrame() {
        let screenFrame = NSRect(x: 0, y: 0, width: 1440, height: 900)
        let visibleFrame = NSRect(x: 0, y: 0, width: 1440, height: 865)
        let tabSize = NSSize(width: 76, height: 30)

        let origin = TabPositioning.constrainedOrigin(
            NSPoint(x: 500, y: 900),
            size: tabSize,
            visibleFrame: visibleFrame,
            screenFrame: screenFrame
        )

        XCTAssertEqual(origin.y, 870)
    }

    func testTabBottomAndHorizontalEdgesStayInsideVisibleFrame() {
        let screenFrame = NSRect(x: 0, y: 0, width: 1440, height: 900)
        let visibleFrame = NSRect(x: 24, y: 40, width: 1392, height: 825)
        let tabSize = NSSize(width: 76, height: 30)

        let origin = TabPositioning.constrainedOrigin(
            NSPoint(x: -100, y: -100),
            size: tabSize,
            visibleFrame: visibleFrame,
            screenFrame: screenFrame
        )

        XCTAssertEqual(origin.x, 32)
        XCTAssertEqual(origin.y, 48)
    }
}
