# Codex Usage Nano

English | [日本語](README.ja.md)

Codex Usage Nano is a small macOS app for seeing Codex usage immediately. It is powered by the local `CodexBarCLI` command included with CodexBar.

It gives you a small floating usage tab without adding another menu bar item that can hide around the MacBook notch.

## Preview

<table>
  <tr>
    <td align="center"><strong>Hover percentage</strong></td>
    <td align="center"><strong>Drag and open panel</strong></td>
  </tr>
  <tr>
    <td><img src="screenshots/codex-usage-nano-demo-hover.gif" alt="Codex Usage Nano collapsed tab expanding to show the Session percentage on hover" width="380"></td>
    <td><img src="screenshots/codex-usage-nano-demo-panel.gif" alt="Codex Usage Nano floating tab being dragged and opening the detail panel" width="380"></td>
  </tr>
</table>

<table>
  <tr>
    <td align="center"><strong>Collapsed tab</strong></td>
    <td align="center"><strong>Hover</strong></td>
    <td align="center"><strong>Hover + panel</strong></td>
    <td align="center"><strong>Detail panel</strong></td>
  </tr>
  <tr>
    <td><img src="screenshots/codex-usage-nano-collapsed.png" alt="Collapsed Codex Usage Nano tab with Session and Weekly bars" width="210"></td>
    <td><img src="screenshots/codex-usage-nano-hover.png" alt="Hovered Codex Usage Nano tab showing the Session percentage" width="210"></td>
    <td><img src="screenshots/codex-usage-nano-hover-panel.png" alt="Hovered Codex Usage Nano tab with the detail panel open" width="210"></td>
    <td><img src="screenshots/codex-usage-nano-panel.png" alt="Codex Usage Nano detail panel" width="210"></td>
  </tr>
</table>

## Why this exists

Menu bar usage meters are easy to miss on a busy desktop. On notched MacBook displays, they can also be pushed into awkward or hidden positions.

Codex Usage Nano stays as a small draggable floating tab instead. Put it where your eyes naturally go, hover for the Session percentage, or click once for the detail panel.

## Features

- Floating tab with Session and Weekly bars
- Hover to show the Session percentage
- Click to open or hide the detail panel
- Drag anywhere and remember the position
- Resize and reposition the detail panel
- Automatic refresh plus manual refresh from the tab menu
- Local CodexBarCLI usage retrieval with no Dock or menu bar item while running

## Requirements

- macOS 14 or newer
- CodexBar installed at `/Applications/CodexBar.app`
- CodexBar configured with the `codex` provider
- Swift toolchain only if building from source

CodexBar does not need to be open while Codex Usage Nano is running. The app calls the installed `CodexBarCLI` directly.

## Install

### Download release build

Download the latest `CodexUsageNano-*-macos.zip` from [GitHub Releases](https://github.com/AkiGarage/codex-usage-nano/releases/latest), unzip it, and move `CodexUsageNano.app` to `/Applications`.

Then open it:

```bash
open -n /Applications/CodexUsageNano.app
```

If macOS blocks the app as unidentified, open System Settings > Privacy & Security and allow `CodexUsageNano.app`.

### Build from source

```bash
git clone https://github.com/AkiGarage/codex-usage-nano.git
cd codex-usage-nano
./script/build_and_run.sh --verify
ditto dist/CodexUsageNano.app /Applications/CodexUsageNano.app
open -n /Applications/CodexUsageNano.app
```

## Usage

| Action | How |
| --- | --- |
| Launch | Open `CodexUsageNano.app` from `/Applications`. |
| Show or hide detail panel | Click the floating tab. |
| Move the tab | Drag the tab. Its position is saved for the next launch. |
| Move or resize the panel | Drag the panel background to move it, or drag a corner/edge to resize it. |
| Refresh | Right-click, two-finger tap, or Control-click the tab, then choose `Refresh`. |
| Adjust opacity | Two-finger swipe on the detail panel or the tab. Double-click the tab to restore 100% opacity and reset the default tab-panel relation. |
| Quit | Use the tab menu, or run `pkill -x CodexUsageNano`. |

The collapsed tab shows Session on the top bar and Weekly on the bottom bar. Session is the current five-hour Codex usage window; Weekly is the weekly limit. The detail panel adds reset timing, pace, projections, and larger bars.

![Tab menu with Show Panel, Refresh, and Quit](screenshots/tab-menu.png)

## Privacy

- The app does not store OpenAI tokens, cookies, or passwords.
- It does not bundle or redistribute CodexBar.
- It calls the local `/Applications/CodexBar.app/Contents/Helpers/CodexBarCLI`.
- Any local snapshot is sanitized and only contains display-friendly usage data.
- No broad LAN server is exposed.

Local snapshots may be written to:

```text
~/Library/Application Support/CodexUsageNano/latest-usage-snapshot.json
/private/tmp/codex-usage-nano/latest-usage-snapshot.json
```

## Troubleshooting

### `CodexBarCLI not found`

Confirm CodexBar is installed in `/Applications`.

```bash
ls /Applications/CodexBar.app/Contents/Helpers/CodexBarCLI
```

### Usage does not update

Check whether CodexBarCLI can return usage directly.

```bash
/Applications/CodexBar.app/Contents/Helpers/CodexBarCLI usage --provider codex --no-color
```

If that command fails, open CodexBar and check that its `codex` provider is configured.

### Tab or panel appears in a strange place

Reset the saved app position and settings.

```bash
defaults delete local.codex.CodexUsageNano
open -n /Applications/CodexUsageNano.app
```

### macOS blocks the app

Open System Settings > Privacy & Security, find the blocked app notice, and allow `CodexUsageNano.app`.

## Uninstall

Quit the app, move `CodexUsageNano.app` to Trash, and remove saved settings.

```bash
pkill -x CodexUsageNano
defaults delete local.codex.CodexUsageNano
```

## License and credit

MIT License. See [LICENSE](LICENSE).

Codex Usage Nano is a companion app for [steipete/CodexBar](https://github.com/steipete/CodexBar), which is also MIT licensed.

See [CHANGELOG.md](CHANGELOG.md) for release history.
