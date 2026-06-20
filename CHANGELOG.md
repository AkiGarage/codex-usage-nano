# Changelog

All notable changes to Codex Usage Nano are documented here.

## Unreleased

### Changed

- Replaced the README video link with an inline animated GIF preview for reliable GitHub rendering.

## 0.0.2 - 2026-06-21

### Changed

- Renamed the project to Codex Usage Nano.
- Renamed the SwiftPM package, macOS app bundle, executable, and screenshots to use the Nano name.
- Rewrote README content for general users.
- Removed private-snapshot naming and owner-specific metadata from public-facing files.

## 0.0.1 - 2026-06-07

First stable release.

### Added

- Floating macOS tab for quick Codex usage checks without adding a menu bar item.
- Click-to-toggle detailed usage panel.
- Draggable tab with saved position.
- Top-screen and menu-bar-adjacent tab placement.
- Resizable detailed panel with responsive text, spacing, bars, and markers.
- Session and Weekly usage display using the installed CodexBarCLI.
- Reset time, pace, deficit, projected empty, and run-out labels aligned with current CodexBar output.
- Cyan, yellow, and red usage bars for normal, warning, and critical states.
- Expected-usage red marker on the bars.
- Panel opacity control with two-finger swipe.
- Recovery path from the tab when the panel becomes too transparent to interact with.
- Tab double-click to restore the panel at 100% opacity.
- Distinct cyan `OP <percent>%` opacity display so opacity mode is not confused with normal `C <percent>%` usage mode.
- App icon and `/Applications`-friendly `.app` bundle metadata.
- Beginner-friendly Japanese and English README.

### Credits

- This app is a companion for [steipete/CodexBar](https://github.com/steipete/CodexBar).
- It does not bundle or redistribute CodexBar. It calls the installed `CodexBarCLI` as the usage data source.
