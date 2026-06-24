# Codex Usage Nano v0.0.3 Release Draft

This is the draft release note and pre-publish checklist for `v0.0.3`.

Do not create the GitHub Release, push the tag, or upload release assets until a
maintainer explicitly approves publishing.

## Scope

`v0.0.3` is a macOS-only release.

It includes:

- the current Codex Usage Nano macOS app,
- updated English and Japanese README pages with matching content,
- the inline README demo GIFs, current screenshots, tab-menu screenshot, and app icon,
- all current macOS feature documentation,
- `CFBundleShortVersionString` set to `0.0.3`.

It does not include:

- an iPhone app,
- an iOS widget,
- an iOS sync flow,
- CodexBar source code or binaries,
- OpenAI / Codex credentials, cookies, or tokens.

## Release Title

```text
Codex Usage Nano 0.0.3
```

## Tag

```text
v0.0.3
```

## Asset

```text
CodexUsageNano-0.0.3-macos.zip
```

## Draft GitHub Release Notes

```markdown
## Codex Usage Nano 0.0.3

This is a macOS-only release of Codex Usage Nano, a tiny draggable Codex usage
tab for MacBooks with a notch.

### Highlights

- Updated both English and Japanese README pages with matching `v0.0.3` content.
- Documented all current macOS features:
  - collapsed floating tab with Session / Weekly color bars,
  - mouseover percentage display for Session remaining tokens,
  - draggable floating tab with saved position,
  - one-click Session / Weekly detail panel,
  - saved detail-panel offset near the tab,
  - detail panel movement by dragging,
  - detail panel resize by dragging,
  - automatic refresh and manual refresh,
  - tab menu for show / hide, refresh, and quit,
  - two-finger opacity adjustment,
  - opacity recovery from the tab,
  - double-click restore for 100% opacity and the default tab / detail-panel relationship,
  - cyan opacity-mode display on the tab plus `OP NN%` on the detail panel,
  - local CodexBarCLI usage source and privacy boundary.
- Added the app icon near the top of both README pages.
- Uses inline README GIFs and current screenshots for reliable GitHub rendering.
- Removed the unreleased iOS companion project and iOS planning document from
  the release surface.

### Install

1. Download `CodexUsageNano-0.0.3-macos.zip`.
2. Unzip it.
3. Move `CodexUsageNano.app` to `/Applications`.
4. Open `CodexUsageNano.app`.

CodexBar must be installed at `/Applications/CodexBar.app`, with the `codex`
provider configured. The CodexBar app does not need to be running while Codex
Usage Nano refreshes usage through the installed `CodexBarCLI`.

### Privacy

Codex Usage Nano does not store OpenAI / Codex credentials, cookies, passwords,
or tokens. Usage retrieval stays local through the installed `CodexBarCLI`.
```

## Pre-Publish Checklist

- `swift test`
- `TZ=UTC swift test`
- `swift build -Xswiftc -strict-concurrency=complete`
- `./script/build_and_run.sh --verify`
- Verify `/Applications/CodexBar.app/Contents/Helpers/CodexBarCLI` is not
  bundled into the app.
- Verify `Support/Info.plist` contains `CFBundleShortVersionString` `0.0.3`.
- Verify `README.md` and `README.ja.md` have matching structure and content.
- Verify no tracked `iOS/` files remain.
- Verify no private paths, secrets, credential files, or handoff files are
  tracked.
- Create `CodexUsageNano-0.0.3-macos.zip`.
- Record the SHA256 for the zip.
- Re-fetch repository, tag, release, and Actions state before publishing.
