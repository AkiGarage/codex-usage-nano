# Development Log

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
