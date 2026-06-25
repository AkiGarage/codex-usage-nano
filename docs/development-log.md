# Development Log

## 2026-06-25

- Prepared the public `v0.0.5` release branch and opened draft PR `#7`.
- Ported the latest macOS visual refresh into the public Nano tree: translucent
  glass-style floating tab, detail panel, opacity HUD, and usage bars while
  preserving the existing no-menu-bar primary UX and macOS 14 compatibility.
- Ported the zero-percent tab bar fix so exactly 0% remaining leaves no colored
  sliver in the collapsed tab.
- Updated `CFBundleShortVersionString` to `0.0.5`.
- Updated `README.md`, `README.ja.md`, and `CHANGELOG.md` with matching public
  `v0.0.5` release text and the `CodexUsageNano-0.0.5-macos.zip` asset name.
- Added `docs/release-v0.0.5.md` as the draft release note and pre-publish
  checklist.
- GitHub PR checks passed on PR `#7`.
- README / README.ja GitHub-rendered visual approval, tag creation, release
  asset upload, and GitHub Release publishing remain pending explicit
  maintainer approval.

## 2026-06-24

- Prepared the local public `v0.0.4` release snapshot without publishing.
- Ported the latest private macOS implementation into the public Nano tree:
  compact default detail-panel size, panel double-click size reset,
  edge/corner resizing, clearer resize feedback, and older-SDK-safe dynamic
  AppKit resize cursor lookup.
- Added `UsageSnapshotPublisher` so successful refreshes write a sanitized
  local JSON snapshot under Application Support and `/private/tmp`.
- Updated `CFBundleShortVersionString` to `0.0.4`.
- Updated `README.md` and `README.ja.md` with matching public `v0.0.4`
  content, including macOS-only scope, resize/reset behavior, local snapshot
  privacy notes, and the `CodexUsageNano-0.0.4-macos.zip` asset name.
- Added `docs/release-v0.0.4.md` as the draft release note and pre-publish
  checklist.
- Publishing, pushing, tag creation, and release asset upload remain pending
  explicit maintainer approval.

## 2026-06-22

- Prepared the public `v0.0.3` release as a macOS-only release.
- Removed the unreleased iOS companion project and iOS companion planning doc from the public release surface.
- Updated `CFBundleShortVersionString` to `0.0.3`.
- Rewrote the English and Japanese README pages with matching content and all current macOS features:
  floating tab, top-edge placement, saved position, detail panel, responsive resize, automatic/manual refresh, tab menu, opacity adjustment, tab-based opacity recovery, double-click restore, `OP <percent>%` HUD, CodexBarCLI dependency, and privacy boundary.
- Moved the previously unreleased README demo improvements into `CHANGELOG.md` under `0.0.3`.
- Ported the latest floating-tab interaction into the Nano release branch:
  collapsed Session / Weekly color bars, mouseover percentage display, drag-time collapse, saved detail-panel offset, and double-click reset of panel opacity and placement.
- Replaced README media with the latest GIFs and screenshots for the collapsed tab, mouseover state, mouseover + detail panel, detail panel, and tab menu.
- Updated the English and Japanese README pages so product name, version, screenshots, CodexBar runtime note, opacity-mode explanation, and user-facing behavior are aligned.

## 2026-06-21

- Added compressed README demo assets from a macOS screen recording.
- Placed the demo near the top of both localized README pages to highlight the draggable floating tab, one-click detail panel, and menu-bar-independent placement.
- Replaced the README `<video>` embed with a GitHub-friendly preview image link because GitHub README rendering may not show local MP4 embeds consistently.
- Replaced the preview image / MP4 link with an inline GIF so the demo renders directly in the README.
- Recut the README GIF around the top edge so menu-bar-adjacent placement is visible instead of being lost in a full-screen downscale.
- Recut the README GIF with a wider top-region crop so the entire detail panel remains visible.
- Added a lightweight README app icon image generated from `Support/AppIcon.png`.
