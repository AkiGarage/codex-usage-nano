import AppKit
import SwiftUI

final class OpacityAdjustingHostingView<Content: View>: NSHostingView<Content> {
    var onOpacityDelta: ((CGFloat) -> Void)?

    override func scrollWheel(with event: NSEvent) {
        let deltaY = event.scrollingDeltaY
        guard deltaY != 0 else {
            super.scrollWheel(with: event)
            return
        }
        onOpacityDelta?(deltaY)
    }
}
