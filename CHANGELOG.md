# Changelog

All notable changes to Codex Usage Nano are documented here.

## Unreleased

### Changed

- Rewrote the English and Japanese README pages around the current macOS app, with latest-release install links instead of hardcoded version text.
- Clarified the vulnerability reporting path without promising a README security contact.

## 0.0.5 - 2026-06-25

### Changed

- Refreshed the floating tab, detail panel, opacity HUD, and usage bars with translucent glass-style macOS surfaces while keeping macOS 14 compatibility.
- Reduced the painted-gradient look of the detail panel so underlying desktop content reads more naturally through the material.
- Updated English and Japanese README install/version text for the `v0.0.5` release asset.

### Fixed

- Fixed the collapsed tab usage bars so exactly 0% remaining shows a neutral track with no colored sliver.

## 0.0.4 - 2026-06-24

### Changed

- Ported the latest macOS detail-panel behavior into the public Nano release surface.
- Reduced the default detail-panel size.
- Added detail-panel double-click reset for the default panel size.
- Restored native macOS panel resize behavior from active edges and corners.
- Improved detail-panel resize feedback at the active edges and corners.
- Avoided compile-time references to newer AppKit resize cursor APIs so older macOS SDK CI runners can build.
- Added local sanitized usage snapshot publishing after successful refreshes.
- Updated the English and Japanese README pages with matching `v0.0.4` content, current install asset names, resize behavior, reset behavior, and privacy notes.
- Added runtime verification scripts for resize cursor display and resize interaction.

## 0.0.3 - 2026-06-22

### Changed

- Replaced the README video link with an inline animated GIF preview for reliable GitHub rendering.
- Recut the README GIF so drag-anywhere placement is visible.
- Recut the README GIF again so the full detail panel remains visible.
- Added the app icon near the top of both README pages.
- Rewrote the English and Japanese README pages with matching macOS-only `v0.0.3` content.
- Updated the app and README to the latest floating-tab interaction: collapsed Session / Weekly color bars, mouseover percentage display, drag-anywhere placement, and one-click detail panel.
- Documented opacity mode accurately: the tab percentage turns cyan while the detail panel shows an `OP NN%` badge.
- Documented CodexBar accurately: CodexBar must be installed, but the CodexBar app does not need to be running while Codex Usage Nano refreshes through `CodexBarCLI`.
- Updated release install instructions for `CodexUsageNano-0.0.3-macos.zip`.

### Removed

- Removed the unreleased iOS companion project and iOS planning document from the public release surface.

## 0.0.2 - 2026-06-21

### Changed

- Renamed the project to Codex Usage Nano.
- Renamed the SwiftPM package, macOS app bundle, executable, and screenshots to use the Nano name.
- Rewrote README content for general users.
- Removed pre-release snapshot naming and owner-specific metadata from public-facing files.

## 0.0.1 - 2026-06-07

First stable release.

### Added

- Floating macOS tab for quick Codex usage checks without adding a menu bar item.
- Click-to-toggle detailed usage panel.
- Draggable tab with saved position.
- Drag-anywhere tab placement.
- Resizable detailed panel with responsive text, spacing, bars, and markers.
- Session and Weekly usage display using the installed CodexBarCLI.
- Reset time, pace, deficit, projected empty, and run-out labels aligned with current CodexBar output.
- Cyan, yellow, and red usage bars for normal, warning, and critical states.
- Expected-usage red marker on the bars.
- Panel opacity control with two-finger swipe.
- Recovery path from the tab when the panel becomes too transparent to interact with.
- Tab double-click to restore the panel at 100% opacity and reset the default tab / detail-panel relationship.
- Distinct cyan `OP NN%` opacity display so opacity mode is not confused with normal usage display.
- App icon and `/Applications`-friendly `.app` bundle metadata.
- Beginner-friendly Japanese and English README.

### Credits

- This app is a companion for [steipete/CodexBar](https://github.com/steipete/CodexBar).
- It does not bundle or redistribute CodexBar. It calls the installed `CodexBarCLI` as the usage data source.
