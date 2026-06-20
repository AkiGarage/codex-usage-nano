import AppKit
import SwiftUI

final class DraggableTabHostingView<Content: View>: NSHostingView<Content> {
    var onClick: (() -> Void)?
    var onDoubleClick: (() -> Void)?
    var onContextMenu: ((NSEvent) -> Void)?
    var onMove: ((NSPoint) -> Void)?
    var onMoveEnded: (() -> Void)?
    var onOpacityDelta: ((CGFloat) -> Void)?

    override func mouseDown(with event: NSEvent) {
        if event.modifierFlags.contains(.control) {
            onContextMenu?(event)
            return
        }

        if event.clickCount >= 2 {
            onDoubleClick?()
            return
        }

        guard let window else { return }

        let startMouse = NSEvent.mouseLocation
        let startOrigin = window.frame.origin
        var didDrag = false

        while true {
            guard let nextEvent = window.nextEvent(matching: [.leftMouseDragged, .leftMouseUp]) else {
                continue
            }

            switch nextEvent.type {
            case .leftMouseDragged:
                let currentMouse = NSEvent.mouseLocation
                let delta = NSPoint(
                    x: currentMouse.x - startMouse.x,
                    y: currentMouse.y - startMouse.y
                )
                if hypot(delta.x, delta.y) > 3 {
                    didDrag = true
                }
                if didDrag {
                    onMove?(
                        NSPoint(
                            x: startOrigin.x + delta.x,
                            y: startOrigin.y + delta.y
                        )
                    )
                }
            case .leftMouseUp:
                if didDrag {
                    onMoveEnded?()
                } else {
                    onClick?()
                }
                return
            default:
                break
            }
        }
    }

    override func rightMouseDown(with event: NSEvent) {
        onContextMenu?(event)
    }

    override func scrollWheel(with event: NSEvent) {
        let deltaY = event.scrollingDeltaY
        guard deltaY != 0 else {
            super.scrollWheel(with: event)
            return
        }
        onOpacityDelta?(deltaY)
    }
}
