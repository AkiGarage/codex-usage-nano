# Codex Usage Nano v0.0.5 Release Draft

This is the draft release note and pre-publish checklist for `v0.0.5`.

Do not create the GitHub Release, push the tag, or upload release assets until a
maintainer explicitly approves publishing.

## Scope

`v0.0.5` is a macOS-only release.

It includes:

- the current Codex Usage Nano macOS app,
- translucent glass-style surfaces for the floating tab, detail panel, opacity
  HUD, and usage bars,
- the zero-percent tab bar fix so exactly 0% remaining shows no colored sliver,
- updated English and Japanese README pages with matching `v0.0.5` content,
- the existing inline README demo GIFs, screenshots, tab-menu screenshot, and
  app icon,
- the existing compact detail-panel size, resize behavior, reset behavior, and
  local sanitized usage snapshot publishing,
- `CFBundleShortVersionString` set to `0.0.5`.

It does not include:

- an iPhone app,
- an iOS widget,
- an iOS sync backend,
- CodexBar source code or binaries,
- OpenAI / Codex credentials, cookies, or tokens,
- internal handoff files, agent configuration files, local continuity notes, or
  private repo history.

## Release Title

```text
Codex Usage Nano 0.0.5
```

## Tag

```text
v0.0.5
```

## Asset

```text
CodexUsageNano-0.0.5-macos.zip
```

## Draft GitHub Release Notes

```markdown
## Codex Usage Nano 0.0.5

This is a macOS-only release of Codex Usage Nano, a tiny draggable Codex usage
tab for MacBooks with a notch.

### Highlights

- Refreshed the floating tab, detail panel, opacity HUD, and usage bars with
  translucent glass-style macOS surfaces.
- Kept the existing lightweight workflow:
  - collapsed Session / Weekly color bars,
  - mouseover Session percentage display,
  - draggable saved tab position,
  - one-click Session / Weekly detail panel,
  - automatic refresh and manual refresh,
  - opacity adjustment and recovery from the tab.
- Fixed exactly 0% remaining so the collapsed tab bars show only the neutral
  track with no colored sliver.
- Kept usage retrieval local through the installed `CodexBarCLI`.

### Install

1. Download `CodexUsageNano-0.0.5-macos.zip`.
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
- Verify `Support/Info.plist` contains `CFBundleShortVersionString` `0.0.5`.
- Verify `README.md` and `README.ja.md` have matching structure and content.
- Verify no tracked `iOS/` files remain.
- Verify no private paths, secrets, credential files, agent configuration files,
  local continuity notes, or handoff files are tracked.
- Create `CodexUsageNano-0.0.5-macos.zip` with `COPYFILE_DISABLE=1 zip` or an
  equivalent archive command that avoids AppleDouble and Finder metadata.
- Reject archives containing `__MACOSX`, `.DS_Store`, or `._*` files.
- Extract the exact archive that will be uploaded and verify the app version and
  signature from the extracted copy.
- Record the SHA256 for the zip.
- Re-fetch repository, tag, release, and Actions state before publishing.
