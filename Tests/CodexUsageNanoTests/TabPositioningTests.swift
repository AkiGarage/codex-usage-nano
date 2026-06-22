import AppKit
import XCTest
@testable import CodexUsageNano

final class TabPositioningTests: XCTestCase {
    func testPanelOffsetStoreResetClearsSavedOffset() {
        let suiteName = "PanelOffsetStoreTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }
        let store = PanelOffsetStore(defaults: defaults)

        store.save(NSSize(width: -120, height: -240))
        XCTAssertEqual(store.load(), NSSize(width: -120, height: -240))

        store.reset()

        XCTAssertNil(store.load())
        XCTAssertFalse(store.hasSavedOffset)
    }

    func testEdgeTabPresentationUsesSlimCollapsedBar() {
        XCTAssertEqual(EdgeTabPresentation.size(for: .collapsed), CGSize(width: 52, height: 16))
        XCTAssertEqual(EdgeTabPresentation.size(for: .dragging), CGSize(width: 52, height: 16))
        XCTAssertEqual(EdgeTabPresentation.size(for: .expanded), CGSize(width: 52, height: 30))
    }

    func testTabWindowLevelCanOccupyMenuBarArea() {
        XCTAssertEqual(TabPositioning.windowLevel, .statusBar)
        XCTAssertGreaterThan(TabPositioning.windowLevel.rawValue, NSWindow.Level.floating.rawValue)
    }

    func testPanelCentersUnderTopTabWithSmallGap() {
        let visibleFrame = NSRect(x: 0, y: 0, width: 1470, height: 923)
        let panelSize = NSSize(width: 360, height: 190)
        let tabFrame = NSRect(x: 709, y: 926, width: 52, height: 30)

        let origin = TabPositioning.panelOrigin(
            size: panelSize,
            anchor: tabFrame,
            visibleFrame: visibleFrame,
            screenFrame: NSRect(x: 0, y: 0, width: 1470, height: 956)
        )

        XCTAssertEqual(origin.x + panelSize.width / 2, tabFrame.midX)
        XCTAssertEqual(origin.y + panelSize.height + TabPositioning.panelTopGap, tabFrame.minY)
    }

    func testPanelClampsHorizontallyNearRightEdge() {
        let visibleFrame = NSRect(x: 0, y: 0, width: 1470, height: 923)
        let panelSize = NSSize(width: 360, height: 190)
        let tabFrame = NSRect(x: 1400, y: 926, width: 52, height: 30)

        let origin = TabPositioning.panelOrigin(
            size: panelSize,
            anchor: tabFrame,
            visibleFrame: visibleFrame,
            screenFrame: NSRect(x: 0, y: 0, width: 1470, height: 956)
        )

        XCTAssertEqual(origin.x + panelSize.width + TabPositioning.edgePadding, visibleFrame.maxX)
        XCTAssertEqual(origin.y + panelSize.height + TabPositioning.panelTopGap, tabFrame.minY)
    }

    func testPanelClampsHorizontallyNearLeftEdge() {
        let visibleFrame = NSRect(x: 0, y: 0, width: 1470, height: 923)
        let panelSize = NSSize(width: 360, height: 190)
        let tabFrame = NSRect(x: 4, y: 926, width: 52, height: 30)

        let origin = TabPositioning.panelOrigin(
            size: panelSize,
            anchor: tabFrame,
            visibleFrame: visibleFrame,
            screenFrame: NSRect(x: 0, y: 0, width: 1470, height: 956)
        )

        XCTAssertEqual(origin.x, visibleFrame.minX + TabPositioning.edgePadding)
        XCTAssertEqual(origin.y + panelSize.height + TabPositioning.panelTopGap, tabFrame.minY)
    }

    func testSavedPanelOffsetRestoresRelativePosition() {
        let visibleFrame = NSRect(x: 0, y: 0, width: 1470, height: 923)
        let panelSize = NSSize(width: 360, height: 190)
        let tabFrame = NSRect(x: 700, y: 700, width: 52, height: 30)
        let savedOffset = NSSize(width: -120, height: -240)

        let origin = TabPositioning.panelOrigin(
            size: panelSize,
            anchor: tabFrame,
            savedOffset: savedOffset,
            visibleFrame: visibleFrame,
            screenFrame: NSRect(x: 0, y: 0, width: 1470, height: 956)
        )

        XCTAssertEqual(origin.x, tabFrame.minX + savedOffset.width)
        XCTAssertEqual(origin.y, tabFrame.minY + savedOffset.height)
    }

    func testSavedPanelOffsetIsClampedOnScreen() {
        let visibleFrame = NSRect(x: 0, y: 0, width: 1470, height: 923)
        let panelSize = NSSize(width: 360, height: 190)
        let tabFrame = NSRect(x: 1400, y: 910, width: 52, height: 30)
        let savedOffset = NSSize(width: 100, height: 100)

        let origin = TabPositioning.panelOrigin(
            size: panelSize,
            anchor: tabFrame,
            savedOffset: savedOffset,
            visibleFrame: visibleFrame,
            screenFrame: NSRect(x: 0, y: 0, width: 1470, height: 956)
        )

        XCTAssertEqual(origin.x + panelSize.width + TabPositioning.edgePadding, visibleFrame.maxX)
        XCTAssertEqual(origin.y + panelSize.height + TabPositioning.edgePadding, 956)
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

    func testTabResizeKeepsTopEdgeWhenDockedAtScreenTop() {
        let screenFrame = NSRect(x: 0, y: 0, width: 1440, height: 900)
        let visibleFrame = NSRect(x: 0, y: 0, width: 1440, height: 865)
        let currentFrame = NSRect(origin: NSPoint(x: 1328, y: 884), size: EdgeTabPresentation.collapsedSize)

        let origin = TabPositioning.resizedOrigin(
            from: currentFrame,
            to: EdgeTabPresentation.expandedSize,
            visibleFrame: visibleFrame,
            screenFrame: screenFrame
        )

        XCTAssertEqual(origin.y + EdgeTabPresentation.expandedSize.height, screenFrame.maxY)
    }
}
