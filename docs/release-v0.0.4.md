# Codex Usage Nano v0.0.4 Release Draft

This is the draft release note and pre-publish checklist for `v0.0.4`.

Do not create the GitHub Release, push the tag, or upload release assets until a
maintainer explicitly approves publishing.

## Scope

`v0.0.4` is a macOS-only release.

It includes:

- the current Codex Usage Nano macOS app,
- updated English and Japanese README pages with matching content,
- the inline README demo GIFs, current screenshots, tab-menu screenshot, and app icon,
- compact default detail-panel size,
- panel double-click reset for the default panel size,
- native macOS detail-panel resize behavior from active edges and corners,
- clearer resize feedback at the active edges and corners,
- older-SDK-safe dynamic AppKit resize cursor lookup,
- local sanitized usage snapshot publishing after successful refreshes,
- runtime verification scripts for resize cursor display and resize interaction,
- `CFBundleShortVersionString` set to `0.0.4`.

It does not include:

- an iPhone app,
- an iOS widget,
- an iOS sync backend,
- CodexBar source code or binaries,
- OpenAI / Codex credentials, cookies, or tokens,
- internal handoff files, agent configuration files, local continuity notes, or private repo history.

## Release Title

```text
Codex Usage Nano 0.0.4
```

## Tag

```text
v0.0.4
```

## Asset

```text
CodexUsageNano-0.0.4-macos.zip
```

## Draft GitHub Release Notes

```markdown
## Codex Usage Nano 0.0.4

This is a macOS-only release of Codex Usage Nano, a tiny draggable Codex usage
tab for MacBooks with a notch.

### Highlights

- Updated both English and Japanese README pages with matching `v0.0.4` content.
- Added the latest detail-panel behavior:
  - compact default detail-panel size,
  - native macOS resize behavior from active edges and corners,
  - panel double-click reset for the default panel size,
  - tab double-click restore for 100% opacity and the default tab / panel relationship.
- Kept the floating tab workflow:
  - collapsed Session / Weekly color bars,
  - mouseover Session percentage display,
  - draggable saved tab position,
  - one-click Session / Weekly detail panel,
  - automatic refresh and manual refresh,
  - opacity adjustment and recovery from the tab.
- Added local sanitized usage snapshot publishing after successful refreshes.
- Kept usage retrieval local through the installed `CodexBarCLI`.

### Install

1. Download `CodexUsageNano-0.0.4-macos.zip`.
2. Unzip it.
3. Move `CodexUsageNano.app` to `/Applications`.
4. Open `CodexUsageNano.app`.

CodexBar must be installed at `/Applications/CodexBar.app`, with the `codex`
provider configured. The CodexBar app does not need to be running while Codex
Usage Nano refreshes usage through the installed `CodexBarCLI`.

### Privacy

Codex Usage Nano does not store OpenAI / Codex credentials, cookies, passwords,
or tokens. Usage retrieval stays local through the installed `CodexBarCLI`.
After successful refreshes, the app may write sanitized local snapshot JSON
containing usage percentages, display text, marker percentages, and timestamps.
The snapshot does not contain cookies, OpenAI tokens, email addresses, raw
CodexBar output, or local user home paths.
```

## Pre-Publish Checklist

- `swift test`
- `TZ=UTC swift test`
- `swift build -Xswiftc -strict-concurrency=complete`
- `./script/build_and_run.sh --verify`
- `xcrun swift script/verify_resize_cursors.swift`
- `RESIZE_TEST_EXPECT_CURSOR=0 RESIZE_TEST_INSET=4 xcrun swift script/verify_resize_interaction.swift`
- `RESIZE_TEST_EXPECT_CURSOR=1 RESIZE_TEST_INSET=3 xcrun swift script/verify_resize_interaction.swift`
- Verify `/Applications/CodexBar.app/Contents/Helpers/CodexBarCLI` is not
  bundled into the app.
- Verify `Support/Info.plist` contains `CFBundleShortVersionString` `0.0.4`.
- Verify `README.md` and `README.ja.md` have matching structure and content.
- Verify no tracked `iOS/` files remain.
- Verify no private paths, secrets, credential files, agent configuration files,
  local continuity notes, or handoff files are tracked.
- Create `CodexUsageNano-0.0.4-macos.zip`.
- Record the SHA256 for the zip.
- Re-fetch repository, tag, release, and Actions state before publishing.
