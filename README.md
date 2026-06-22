# Codex Usage Nano

<table>
  <tr>
    <td><strong>English</strong></td>
    <td><a href="README.ja.md">日本語</a></td>
  </tr>
</table>

Version: `0.0.3`

## Codex Usage Nano is a small macOS app for checking remaining Codex usage at a glance. Its small floating tab shows Session and Weekly remaining tokens with two internal color bars, shows the Session remaining percentage on mouseover, and opens detailed Session / Weekly information with one click. The minimal design stays out of your way and adds no Dock icon or menu bar item.

<p align="center">
  <img src="screenshots/app-icon.png" alt="Codex Usage Nano app icon" width="128">
</p>

## Demo

The GIFs show the primary interaction: the tab has three display states, can be dragged anywhere on screen, and opens the detail panel with one click. It is not a menu bar item, so you can move it away from the notch.

<table>
  <tr>
    <td align="center"><strong>Three display states</strong></td>
    <td align="center"><strong>Place it anywhere</strong></td>
  </tr>
  <tr>
    <td><img src="screenshots/codex-usage-nano-demo-hover.gif" alt="Animated demo showing the tab expanding on hover and collapsing when the pointer leaves" width="380"></td>
    <td><img src="screenshots/codex-usage-nano-demo-panel.gif" alt="Animated demo showing the floating tab being placed anywhere on screen" width="380"></td>
  </tr>
</table>

When the pointer rests on the tab, the compact color bars expand into a large Session remaining percentage. Click the tab to toggle the detail panel. When the pointer leaves, the tab collapses again and shows only the two color bars.

<table>
  <tr>
    <td align="center"><strong>Collapsed tab</strong></td>
    <td align="center"><strong>Mouseover percentage</strong></td>
    <td align="center"><strong>Mouseover + panel</strong></td>
    <td align="center"><strong>Detail panel</strong></td>
  </tr>
  <tr>
    <td><img src="screenshots/codex-usage-nano-collapsed.png" alt="Collapsed Codex Usage Nano tab with two small usage bars" width="210"></td>
    <td><img src="screenshots/codex-usage-nano-hover.png" alt="Hovered Codex Usage Nano tab showing 69 percent remaining" width="210"></td>
    <td><img src="screenshots/codex-usage-nano-hover-panel.png" alt="Hovered Codex Usage Nano tab with detail panel visible" width="210"></td>
    <td><img src="screenshots/codex-usage-nano-panel.png" alt="Codex Usage Nano detail panel opened under the floating tab" width="210"></td>
  </tr>
</table>

## 1. Overview

Codex Usage Nano is a lightweight macOS app for checking remaining Codex usage quickly. Its main surface is a small floating tab that you can drag anywhere on screen.

On notched MacBook Air and MacBook Pro displays, menu bar apps can disappear behind the notch. Codex Usage Nano avoids that problem by staying out of the menu bar. It does not add a Dock icon or a menu bar item while running; it behaves like a tiny accessory app that stays visible only as a floating tab.

This is a companion app for [steipete/CodexBar](https://github.com/steipete/CodexBar). CodexBar must be installed, but the CodexBar app does not need to be running while you use Codex Usage Nano. Codex Usage Nano does not bundle CodexBar, OpenAI credentials, cookies, or tokens; it calls the locally installed `CodexBarCLI` to read usage data.

## 2. What You See

1. Two small color bars in the floating tab: top = Session, bottom = Weekly.
2. A mouseover state that expands the tab vertically and shows the Session remaining percentage.
3. A one-click detail panel with Session and Weekly usage.
4. Remaining percentage, reset timing, pace status, and projection text for each limit.
5. Usage bars with 20% and 50% tick marks.
6. A red expected-usage marker when CodexBar usage data contains pace context.
7. Bar colors: cyan above 30%, yellow from 16% to 30%, and red at 15% or lower.
8. Opacity mode: the tab percentage turns cyan while opacity is being adjusted, and the detail panel also shows an `OP <percent>%` badge.
9. A short error line when `CodexBarCLI` is missing or cannot return usage.

## 3. Main Features

1. Small floating tab with two color bars for Session and Weekly remaining tokens.
2. Mouseover percentage display for quick Session checks without opening the panel.
3. One-click detail panel for Session / Weekly reset timing, pace, projections, and bars.
4. Drag-anywhere placement, including top-edge and menu-bar-adjacent positions for notched MacBooks.
5. Saved tab position plus detail-panel placement that stays near the tab and remains onscreen.
6. Resizable, movable detail panel with opacity adjustment and recovery from the tab.
7. Automatic refresh every 60 seconds, plus manual refresh from the tab menu.
8. Local privacy boundary: usage retrieval stays on this Mac through the installed `CodexBarCLI`.

## 4. Requirements

1. macOS 14 or newer.
2. [CodexBar](https://github.com/steipete/CodexBar) installed at `/Applications/CodexBar.app`.
3. CodexBar configured with a working `codex` provider.
4. Swift toolchain if building from source.

CodexBar must be installed, but it does not need to be running while you use Codex Usage Nano. The app calls the installed `CodexBarCLI` directly when it refreshes usage.

If Swift tools are missing, install Xcode Command Line Tools first.

```bash
xcode-select --install
```

## 5. Install

### 5.1 Use a Release Build

1. Download `CodexUsageNano-0.0.3-macos.zip` from GitHub Releases.
2. Unzip it.
3. Move `CodexUsageNano.app` to `/Applications`.
4. Double-click `CodexUsageNano.app` in `/Applications` to launch it.

If macOS blocks the app as unidentified, open System Settings > Privacy & Security and allow the app.

### 5.2 Build from Source

```bash
git clone https://github.com/AkiGarage/codex-usage-nano.git
cd codex-usage-nano
./script/build_and_run.sh --verify
ditto dist/CodexUsageNano.app /Applications/CodexUsageNano.app
open -n /Applications/CodexUsageNano.app
```

## 6. Usage

### 6.1 Launch

Double-click `CodexUsageNano.app` in `/Applications` (the Applications folder).

You can also launch it from Terminal.

```bash
open -n /Applications/CodexUsageNano.app
```

The app shows a small floating tab on screen.

You can leave CodexBar closed while using Codex Usage Nano. The app calls the installed `CodexBarCLI` directly when it refreshes usage.

### 6.2 Show or Hide the Detail Panel

Click the floating tab.

1. First click: show the detail panel.
2. Second click: hide the detail panel.

### 6.3 Move the Tab

Drag the floating tab. The position is saved and reused on next launch.

You can place it near the top edge or menu bar area to keep usage visible without relying on a menu bar item.

### 6.4 Read the Tab

The collapsed tab shows two small color bars. The top bar is Session, and the bottom bar is Weekly.

Move the pointer over the tab to expand it vertically and show the Session remaining percentage. The normal percentage is black. While opacity is being adjusted, the tab number turns cyan, and the detail panel also shows an `OP <percent>%` badge so you can tell opacity mode apart from usage mode.

Move the pointer away and the tab collapses back to the two color bars.

### 6.5 Move or Resize the Detail Panel

Drag a panel corner. Text, spacing, bars, and markers scale with the panel.

You can also drag the panel background to move the detail panel while it is visible.

### 6.6 Spaces and Fullscreen

The floating tab and detail panel are configured to stay available across Spaces and fullscreen auxiliary contexts.

### 6.7 Refresh Usage

Codex Usage Nano refreshes automatically every 60 seconds.

To refresh immediately, right-click, two-finger tap, or Control-click the floating tab, then choose `Refresh`.

### 6.8 Adjust Opacity

Two-finger swipe over the detail panel. While adjusting opacity, the detail panel shows an `OP <percent>%` badge, and the tab percentage turns cyan instead of black.

You can also adjust opacity from the floating tab. If the panel becomes too transparent to interact with, two-finger swipe on the tab or double-click the tab to recover it.

### 6.9 Use the Tab Menu

Right-click, two-finger tap, or Control-click the floating tab to open the menu.

![Tab menu showing Show Panel, Refresh, and Quit](screenshots/tab-menu.png)

1. `Show Panel` / `Hide Panel`: show or hide the detail panel.
2. `Refresh`: update Codex usage immediately.
3. `Quit Codex Usage Nano`: quit the app.

### 6.10 Quit from Terminal

```bash
pkill -x CodexUsageNano
```

## 7. Launch at Login

1. Open System Settings.
2. Open General.
3. Open Login Items.
4. Click `+`.
5. Select `/Applications/CodexUsageNano.app`.

## 8. Uninstall

Quit the app.

```bash
pkill -x CodexUsageNano
```

Move the app to Trash.

```bash
trash /Applications/CodexUsageNano.app
```

If `trash` is not installed, move `/Applications/CodexUsageNano.app` to Trash from Finder.

Remove saved tab position and app settings.

```bash
defaults delete local.codex.CodexUsageNano
```

## 9. Troubleshooting

### 9.1 `CodexBarCLI not found`

Make sure CodexBar is installed at `/Applications/CodexBar.app`.

```bash
ls /Applications/CodexBar.app/Contents/Helpers/CodexBarCLI
```

### 9.2 Usage Does Not Update

Check CodexBarCLI directly.

```bash
/Applications/CodexBar.app/Contents/Helpers/CodexBarCLI usage --provider codex --no-color
```

If this command fails, fix the CodexBar configuration or login state first.

### 9.3 The Tab Appears in a Strange Place

Reset the saved position.

```bash
defaults delete local.codex.CodexUsageNano
open -n /Applications/CodexUsageNano.app
```

### 9.4 The App Does Not Appear in the Dock

That is intentional. Codex Usage Nano runs as a macOS accessory app so it does not add Dock or menu bar clutter.

### 9.5 macOS Blocks the App

If macOS blocks the downloaded app as unidentified, open System Settings > Privacy & Security and allow the app.

## 10. Privacy and Security

1. Codex Usage Nano does not bundle CodexBar source code or binaries.
2. Codex Usage Nano does not store OpenAI / Codex tokens, cookies, passwords, or credentials.
3. Usage retrieval is delegated to the local `/Applications/CodexBar.app/Contents/Helpers/CodexBarCLI`.
4. The app does not expose usage data through a LAN server.

## 11. License and Credit

Codex Usage Nano is released under the MIT License. See [LICENSE](LICENSE).

Codex Usage Nano is a companion app for [steipete/CodexBar](https://github.com/steipete/CodexBar), which is also released under the MIT License.

## 12. Changelog

See [CHANGELOG.md](CHANGELOG.md).
