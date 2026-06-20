import AppKit
import SwiftUI

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let store = UsageStore(service: CodexUsageService())
    private let panelSize = NSSize(width: 360, height: 190)
    private let tabSize = NSSize(width: 76, height: 30)
    private let tabOriginXKey = "tabOriginX"
    private let tabOriginYKey = "tabOriginY"
    private var panel: NSPanel?
    private var tabPanel: NSPanel?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        createPanel()
        createTabPanel()
        store.start()
    }

    func applicationWillTerminate(_ notification: Notification) {
        store.stop()
    }

    @objc private func togglePanel() {
        guard let panel else { return }
        if panel.isVisible {
            panel.orderOut(nil)
        } else {
            store.refresh()
            if panel.alphaValue <= 0.01 {
                setPanelOpacity(1, showsHUD: false)
            }
            showPanel(context: "toggle")
        }
    }

    private func createPanel() {
        let panel = NSPanel(
            contentRect: frameNearTab(for: panelSize),
            styleMask: [.nonactivatingPanel, .borderless, .resizable],
            backing: .buffered,
            defer: false
        )

        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.standardWindowButton(.closeButton)?.isHidden = true
        panel.standardWindowButton(.miniaturizeButton)?.isHidden = true
        panel.standardWindowButton(.zoomButton)?.isHidden = true
        panel.isMovableByWindowBackground = true
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = true
        panel.animationBehavior = .none
        panel.level = TabPositioning.windowLevel
        panel.minSize = NSSize(width: 180, height: 112)
        panel.maxSize = NSSize(width: 560, height: 320)
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        let panelView = OpacityAdjustingHostingView(rootView: WidgetView(store: store))
        panelView.onOpacityDelta = { [weak self] deltaY in
            self?.adjustPanelOpacity(deltaY: deltaY, context: "panel-scroll")
        }
        panel.contentView = panelView
        self.panel = panel
    }

    private func createTabPanel() {
        let tabPanel = NSPanel(
            contentRect: frameForTab(),
            styleMask: [.nonactivatingPanel, .borderless],
            backing: .buffered,
            defer: false
        )

        tabPanel.isOpaque = false
        tabPanel.backgroundColor = .clear
        tabPanel.hasShadow = true
        tabPanel.animationBehavior = .none
        tabPanel.level = TabPositioning.windowLevel
        tabPanel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        let tabView = DraggableTabHostingView(rootView: EdgeTabView(store: store))
        tabView.onClick = { [weak self] in
            self?.togglePanel()
        }
        tabView.onDoubleClick = { [weak self] in
            self?.resetPanelOpacityAndShow()
        }
        tabView.onOpacityDelta = { [weak self] deltaY in
            self?.adjustPanelOpacity(deltaY: deltaY, context: "tab-scroll")
        }
        tabView.onContextMenu = { [weak self, weak tabView] event in
            guard let tabView else { return }
            self?.showTabMenu(for: tabView, event: event)
        }
        tabView.onMove = { [weak self] origin in
            self?.moveTab(to: origin)
        }
        tabView.onMoveEnded = { [weak self] in
            self?.saveTabPosition()
        }
        tabPanel.contentView = tabView
        tabPanel.orderFrontRegardless()
        self.tabPanel = tabPanel
    }

    private func showTabMenu(for view: NSView, event: NSEvent) {
        let menu = NSMenu()
        let toggleTitle = panel?.isVisible == true ? "Hide Panel" : "Show Panel"
        menu.addItem(NSMenuItem(title: toggleTitle, action: #selector(togglePanel), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Refresh", action: #selector(refreshUsage), keyEquivalent: ""))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit Codex Usage Nano", action: #selector(quitApp), keyEquivalent: "q"))
        menu.items.forEach { $0.target = self }
        NSMenu.popUpContextMenu(menu, with: event, for: view)
    }

    @objc private func refreshUsage() {
        store.refresh()
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }

    private func moveTab(to proposedOrigin: NSPoint) {
        guard let tabPanel else { return }
        tabPanel.setFrameOrigin(constrainedOrigin(proposedOrigin, size: tabPanel.frame.size))

        if panel?.isVisible == true {
            panel?.setFrame(frameNearTab(for: panel?.frame.size ?? panelSize), display: true)
            alignPanelToVisibleTab(context: "moveTab")
        }
    }

    private func showPanel(context: String) {
        guard let panel else { return }
        panel.setFrame(frameNearTab(for: panel.frame.size), display: true)
        panel.orderFrontRegardless()
        tabPanel?.orderFrontRegardless()
        alignPanelToVisibleTab(context: context)
    }

    private func adjustPanelOpacity(deltaY: CGFloat, context: String) {
        guard let panel else { return }
        if !panel.isVisible {
            store.refresh()
            showPanel(context: context)
        } else {
            tabPanel?.orderFrontRegardless()
        }

        let nextOpacity = TabPositioning.adjustedOpacity(
            current: panel.alphaValue,
            scrollDeltaY: deltaY
        )
        setPanelOpacity(nextOpacity, showsHUD: true)
    }

    private func resetPanelOpacityAndShow() {
        setPanelOpacity(1, showsHUD: true)
        store.refresh()
        showPanel(context: "tab-double-click")
    }

    private func setPanelOpacity(_ opacity: CGFloat, showsHUD: Bool) {
        panel?.alphaValue = opacity
        if showsHUD {
            store.showOpacityHUD(percent: TabPositioning.opacityPercent(for: opacity))
        }
    }

    private func saveTabPosition() {
        guard let tabPanel else { return }
        let origin = tabPanel.frame.origin
        UserDefaults.standard.set(origin.x, forKey: tabOriginXKey)
        UserDefaults.standard.set(origin.y, forKey: tabOriginYKey)
    }

    private func frameNearTab(for size: NSSize) -> NSRect {
        let tabFrame = tabPanel?.frame ?? frameForTab()
        return frame(for: size, anchoredTo: tabFrame)
    }

    private func frame(for size: NSSize, anchoredTo anchor: NSRect) -> NSRect {
        let visibleFrame = visibleFrame(containing: anchor)
        let screenFrame = screenFrame(containing: anchor)
        return NSRect(
            origin: TabPositioning.panelOrigin(
                size: size,
                anchor: anchor,
                visibleFrame: visibleFrame,
                screenFrame: screenFrame
            ),
            size: size
        )
    }

    private func frameForTab() -> NSRect {
        if let savedOrigin = savedTabOrigin() {
            return NSRect(
                origin: constrainedOrigin(savedOrigin, size: tabSize),
                size: tabSize
            )
        }

        let screenFrame = widestVisibleFrame()
        let origin = NSPoint(
            x: max(screenFrame.minX + 8, screenFrame.maxX - tabSize.width - 8),
            y: max(screenFrame.minY + 8, screenFrame.midY - tabSize.height / 2)
        )
        return NSRect(origin: origin, size: tabSize)
    }

    private func savedTabOrigin() -> NSPoint? {
        guard UserDefaults.standard.object(forKey: tabOriginXKey) != nil,
              UserDefaults.standard.object(forKey: tabOriginYKey) != nil
        else {
            return nil
        }
        return NSPoint(
            x: UserDefaults.standard.double(forKey: tabOriginXKey),
            y: UserDefaults.standard.double(forKey: tabOriginYKey)
        )
    }

    private func constrainedOrigin(_ origin: NSPoint, size: NSSize) -> NSPoint {
        let rect = NSRect(origin: origin, size: size)
        return TabPositioning.constrainedOrigin(
            origin,
            size: size,
            visibleFrame: visibleFrame(containing: rect),
            screenFrame: screenFrame(containing: rect)
        )
    }

    private func screenFrame(containing rect: NSRect) -> NSRect {
        NSScreen.screens
            .map(\.frame)
            .first { $0.intersects(rect) } ?? widestScreenFrame()
    }

    private func visibleFrame(containing rect: NSRect) -> NSRect {
        NSScreen.screens
            .map(\.visibleFrame)
            .first { $0.intersects(rect) } ?? widestVisibleFrame()
    }

    private func widestVisibleFrame() -> NSRect {
        let screenFrame = NSScreen.screens
            .map(\.visibleFrame)
            .max { $0.width < $1.width } ?? .zero
        return screenFrame
    }

    private func widestScreenFrame() -> NSRect {
        let screenFrame = NSScreen.screens
            .map(\.frame)
            .max { $0.width < $1.width } ?? .zero
        return screenFrame
    }

    private func alignPanelToVisibleTab(context: String) {
        DispatchQueue.main.async { [weak self] in
            self?.alignPanelToVisibleTabNow(context: context)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            self?.alignPanelToVisibleTabNow(context: "\(context):followup")
        }
    }

    private func alignPanelToVisibleTabNow(context: String) {
        guard let panel, let tabPanel, panel.isVisible else { return }
        let visibleFrame = visibleFrame(containing: tabPanel.frame)
        guard tabPanel.frame.maxY > visibleFrame.maxY else { return }
        guard let tabBounds = RuntimeWindowFrames.bounds(for: tabPanel.windowNumber),
              let panelBounds = RuntimeWindowFrames.bounds(for: panel.windowNumber)
        else {
            FrameDiagnostics.log(context: context, tabFrame: tabPanel.frame, panelFrame: panel.frame)
            return
        }

        let delta = panelBounds.minY - tabBounds.maxY
        FrameDiagnostics.log(
            context: context,
            tabFrame: tabPanel.frame,
            panelFrame: panel.frame,
            tabBounds: tabBounds,
            panelBounds: panelBounds,
            delta: delta
        )
        guard abs(delta) > 1 else { return }
        panel.setFrameOrigin(NSPoint(x: panel.frame.origin.x, y: panel.frame.origin.y + delta))
    }
}

enum RuntimeWindowFrames {
    static func bounds(for windowNumber: Int) -> NSRect? {
        let windows = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as? [[String: Any]] ?? []
        for window in windows {
            guard window[kCGWindowNumber as String] as? Int == windowNumber,
                  let bounds = window[kCGWindowBounds as String] as? NSDictionary,
                  let rect = CGRect(dictionaryRepresentation: bounds)
            else { continue }
            return NSRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height)
        }
        return nil
    }
}

enum FrameDiagnostics {
    static func log(
        context: String,
        tabFrame: NSRect,
        panelFrame: NSRect,
        tabBounds: NSRect? = nil,
        panelBounds: NSRect? = nil,
        delta: CGFloat? = nil
    ) {
        let message = [
            "context=\(context)",
            "tabFrame=\(NSStringFromRect(tabFrame))",
            "panelFrame=\(NSStringFromRect(panelFrame))",
            "tabBounds=\(tabBounds.map(NSStringFromRect) ?? "nil")",
            "panelBounds=\(panelBounds.map(NSStringFromRect) ?? "nil")",
            "delta=\(delta.map { String(format: "%.2f", Double($0)) } ?? "nil")"
        ].joined(separator: " ")
        NSLog("CodexUsageNanoFrame %@", message)
        appendToFile(message)
    }

    private static func appendToFile(_ message: String) {
        let url = URL(fileURLWithPath: "/private/tmp/codex-usage-nano-frames.log")
        let line = "\(Date()) \(message)\n"
        guard let data = line.data(using: .utf8) else { return }
        if FileManager.default.fileExists(atPath: url.path),
           let handle = try? FileHandle(forWritingTo: url) {
            handle.seekToEndOfFile()
            handle.write(data)
            try? handle.close()
        } else {
            try? data.write(to: url)
        }
    }
}

enum TabPositioning {
    static let windowLevel = NSWindow.Level.statusBar
    static let panelTopGap: CGFloat = 0

    static func constrainedOrigin(
        _ origin: NSPoint,
        size: NSSize,
        visibleFrame: NSRect,
        screenFrame: NSRect
    ) -> NSPoint {
        NSPoint(
            x: min(max(visibleFrame.minX + 8, origin.x), visibleFrame.maxX - size.width - 8),
            y: min(max(visibleFrame.minY + 8, origin.y), screenFrame.maxY - size.height)
        )
    }

    static func panelOrigin(
        size: NSSize,
        anchor: NSRect,
        visibleFrame: NSRect,
        screenFrame: NSRect
    ) -> NSPoint {
        let x = min(
            max(visibleFrame.minX + 8, anchor.minX - size.width - 8),
            visibleFrame.maxX - size.width - 12
        )
        let y: CGFloat
        if anchor.maxY > visibleFrame.maxY {
            let top = min(anchor.minY - panelTopGap, screenFrame.maxY)
            y = max(visibleFrame.minY + 12, top - size.height)
        } else {
            y = min(
                max(visibleFrame.minY + 12, anchor.midY - size.height / 2),
                visibleFrame.maxY - size.height - 12
            )
        }
        return NSPoint(x: x, y: y)
    }

    static func adjustedOpacity(current: CGFloat, scrollDeltaY: CGFloat) -> CGFloat {
        min(max(current + scrollDeltaY / 500, 0), 1)
    }

    static func opacityPercent(for opacity: CGFloat) -> Int {
        Int((min(max(opacity, 0), 1) * 100).rounded())
    }
}
