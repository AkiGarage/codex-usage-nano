# Codex Usage Widget

[日本語](#日本語) / [English](#english)

Version: `0.0.1`

<table>
  <tr>
    <td align="center"><strong>Normal</strong></td>
    <td align="center"><strong>Warning</strong></td>
    <td align="center"><strong>Critical</strong></td>
  </tr>
  <tr>
    <td><img src="screenshots/codex-usage-widget.png" alt="Codex Usage Widget normal state" width="260"></td>
    <td><img src="screenshots/codex-usage-widget-warning.png" alt="Codex Usage Widget warning state" width="260"></td>
    <td><img src="screenshots/codex-usage-widget-critical.png" alt="Codex Usage Widget critical state" width="260"></td>
  </tr>
</table>

When the remaining session usage gets low, the bar switches from cyan to yellow, then red, so the state is visible at a glance.

## 日本語

### これは何？

Codex Usage Widget は、Codex の残り使用量をすばやく確認するための小さな macOS アプリです。現在の最初の安定版は `0.0.1` です。

技術的には普通の `.app` 形式の macOS アプリですが、Dock やメニューバーに常駐するタイプではありません。画面上に小さな `C 37%` のような floating tab を置き、必要なときだけクリックして詳細パネルを表示する、widget 風のアプリです。

このアプリは [steipete/CodexBar](https://github.com/steipete/CodexBar) の companion app です。CodexBar を改変したものではなく、CodexBar を同梱しているわけでもありません。インストール済みの `CodexBarCLI` を呼び出して、Codex の使用量を取得しています。

### なぜ作ったの？

これは個人的に必要で作った小さなツールです。

Codex を使っていると、残りトークンやリセットまでの時間をすばやく見たい場面があります。ただ、普通のメニューバーアプリとして表示すると、MacBook Air / MacBook Pro の notch がある画面ではすぐに隠れてしまいます。

特にサードパーティー製のメニューバーアプリは、表示できる数がかなり限られます。自分の環境ではだいたい6個くらいを超えると、追加のメニューバー項目が notch の裏側に隠れてしまい、せっかく `Codex 82% left` のような表示があっても見えません。

CodexBar はとても便利ですが、自分のMacではメニューバー表示だけだと常に見える情報として使いにくい、という問題がありました。そこで、メニューバーに依存せず、邪魔にならない場所へ置ける小さな floating widget としてこのアプリを作りました。

同じように「Codex の残り使用量は見たい。でもメニューバーをこれ以上増やしたくない」という人には役に立つかもしれません。

### 何が見える？

- Session の残りパーセント
- Session のリセットまでの時間
- Session の消費ペース、deficit、projected empty
- Weekly の残りパーセント
- Weekly のリセットまでの時間
- Weekly の消費ペース、deficit、runs out
- 残りが少なくなると黄色、さらに少ないと赤になるバー
- 期待使用量の位置を示す赤い marker

### v0.0.1 の主な機能

- メニューバーに項目を増やさない floating tab
- tabをドラッグして好きな場所へ移動
- tabをクリックして詳細パネルを表示 / 非表示
- tabを画面最上部、メニューバー付近まで移動可能
- 詳細パネルは角をドラッグしてリサイズ可能
- 詳細パネルの二本指スワイプで透明度を無段階調整
- 詳細パネルが透明になりすぎても、tabの二本指スワイプで透明度を戻せる
- tabをダブルクリックすると、詳細パネルを100%不透明で復帰
- 透明度調整中は `OP 100%` のように水色で表示
- 通常の残りトークン表示は `C 97%` のように表示
- CodexBarCLIのusage出力に合わせた Session / Weekly 表示
- 残量が減るとバーが水色から黄色、赤へ変化

### 必要なもの

- macOS 14 以降
- [CodexBar](https://github.com/steipete/CodexBar) が `/Applications/CodexBar.app` にインストールされていること
- CodexBar 側で `codex` provider が使える状態になっていること
- このリポジトリからbuildする場合は Swift toolchain が必要です

Swift toolchain が入っていない場合は、まず以下を実行します。

```bash
xcode-select --install
```

### インストール方法

まずリポジトリを取得します。

```bash
git clone https://github.com/AkiGarage/codex-usage-widget-public.git
cd codex-usage-widget-public
```

次にアプリをbuildして起動確認します。

```bash
./script/build_and_run.sh --verify
```

問題なければ `/Applications` にコピーします。

```bash
ditto dist/CodexUsageWidget.app /Applications/CodexUsageWidget.app
open -n /Applications/CodexUsageWidget.app
```

これで画面上に `C 37%` のような小さなtabが表示されます。

### 使い方

#### 表示する

`/Applications/CodexUsageWidget.app` を開きます。

```bash
open -n /Applications/CodexUsageWidget.app
```

起動するとDockではなく、画面上に小さな floating tab が表示されます。

#### 詳細パネルを開く / 閉じる

floating tab をクリックします。

- 1回クリック: 詳細パネルを表示
- もう1回クリック: 詳細パネルを非表示

#### 好きな場所へ動かす

floating tab をドラッグします。移動した位置は保存されるので、次に起動したときも同じ場所に出ます。

#### 小さくする / 大きくする

詳細パネルの角をドラッグするとリサイズできます。

かなり小さくしても、フォントサイズ、行間、バーの高さ、赤いmarkerが自動的に縮小されます。

#### 透明度を変える

詳細パネルの上で二本指スワイプすると、詳細パネルの透明度を無段階で変えられます。

透明度を調整している間は、通常の `C 97%` 表示ではなく、`OP 80%` のような水色の表示に変わります。`OP` は opacity の意味です。残りトークン表示とは色も文字も違うので、今は透明度を見ていると分かります。

#### 透明にしすぎて詳細パネルを触れなくなった場合

詳細パネルがほぼ透明になると、まだ少し見えていてもクリックやスワイプがしづらくなることがあります。

その場合は小さな floating tab の上で二本指スワイプしてください。tab自体の透明度は変わらず、詳細パネルだけの透明度を戻せます。

また、tabをダブルクリックすると、詳細パネルが100%不透明で表示されます。

#### 更新する

通常は自動で定期更新されます。

すぐ更新したい場合は、floating tab を右クリック、または Control-click して、`Refresh` を選びます。

#### 終了する

floating tab を右クリック、または Control-click して、`Quit Codex Usage Widget` を選びます。

もし何らかの理由でmenuが開けない場合は、Terminalから終了できます。

```bash
pkill -x CodexUsageWidget
```

### ログイン時に自動起動したい場合

macOSの標準機能でLogin Itemsに追加できます。

1. System Settings を開く
2. General を開く
3. Login Items を開く
4. `+` を押す
5. `/Applications/CodexUsageWidget.app` を選ぶ

これでMacへログインしたときに自動起動できます。

### アンインストール方法

まずアプリを終了します。

```bash
pkill -x CodexUsageWidget
```

アプリ本体を削除します。

```bash
trash /Applications/CodexUsageWidget.app
```

`trash` コマンドがない場合はFinderで `/Applications/CodexUsageWidget.app` をゴミ箱に入れてください。

保存されたtab位置などの設定も消したい場合は、以下を実行します。

```bash
defaults delete local.codex.CodexUsageWidget
```

cloneしたリポジトリも不要なら削除します。

```bash
trash ~/Dev/codex-usage-widget-public
```

### トラブルシュート

#### `CodexBarCLI not found` と出る

CodexBar が `/Applications/CodexBar.app` に入っているか確認してください。

```bash
ls /Applications/CodexBar.app/Contents/Helpers/CodexBarCLI
```

見つからない場合は、先にCodexBarをインストールしてください。

#### 使用量が更新されない

まずCodexBarCLI単体で使用量が取れるか確認します。

```bash
/Applications/CodexBar.app/Contents/Helpers/CodexBarCLI usage --provider codex --no-color
```

ここでエラーになる場合は、CodexBar側の設定やCodexログイン状態を確認してください。

#### tabが画面の変な場所に出る

位置設定を消すと初期位置に戻ります。

```bash
defaults delete local.codex.CodexUsageWidget
open -n /Applications/CodexUsageWidget.app
```

#### Dockに出ない

これは仕様です。Dockやメニューバーに項目を増やさないため、accessory app として動かしています。

### CodexBarとの関係とライセンス

このアプリは [steipete/CodexBar](https://github.com/steipete/CodexBar) の companion app です。

CodexBarを改変したbuildではありません。CodexBarのsource codeやbinaryをこのリポジトリに同梱していません。インストール済みの `CodexBarCLI` を呼び出して、CodexBarが取得した使用量情報を表示しています。

CodexBarは [MIT License](https://github.com/steipete/CodexBar/blob/main/LICENSE) で公開されています。MIT Licenseは非常に寛容なライセンスで、条件を守れば改変や再配布も許可されます。このプロジェクトではCodexBarへのcreditを明示し、CodexBar本体を同梱しない形にしています。

このリポジトリ自体は `LICENSE` に記載した MIT License で公開します。

### リリース履歴

変更履歴は [CHANGELOG.md](CHANGELOG.md) を見てください。

## English

### What is this?

Codex Usage Widget is a tiny macOS app for checking remaining Codex usage quickly. The first stable personal release is `0.0.1`.

Technically, it is a normal macOS `.app` bundle. In practice, it behaves like a floating widget: it does not add a Dock icon or a menu bar item while running. Instead, it shows a small draggable tab such as `C 37%`; clicking that tab opens or hides the detailed usage panel.

This is a companion app for [steipete/CodexBar](https://github.com/steipete/CodexBar). It is not a modified build or redistribution of CodexBar. It calls the installed `CodexBarCLI` and treats CodexBar as the source of truth for Codex usage.

### Why does this exist?

This started as a personal tool.

I wanted to check remaining Codex usage quickly without adding yet another menu bar item. On MacBook Air and MacBook Pro displays with a notch, third-party menu bar apps can disappear behind the notch once there are too many of them. In my setup, only around six third-party menu bar items are reliably visible; anything beyond that can become hidden and therefore useless for quick status checks.

CodexBar is excellent, but for this specific workflow I could not rely on a menu bar display. I wanted something small, movable, visible only when needed, and independent of the menu bar. That is why this floating tab app exists.

If you have the same problem, this may be useful for you too.

### What does it show?

- Session remaining percent
- Session reset time
- Session pace, deficit, and projected empty time
- Weekly remaining percent
- Weekly reset time
- Weekly pace, deficit, and run-out time
- Warning colors when remaining usage gets low
- A red marker showing expected usage position

### Highlights in v0.0.1

- Floating tab that does not add another menu bar item
- Draggable tab position
- Click the tab to show or hide the detailed panel
- Move the tab all the way near the top of the screen and menu bar area
- Resize the detailed panel by dragging a corner
- Adjust the detailed panel opacity with a two-finger swipe
- Recover panel opacity from the tab even if the panel becomes too transparent to interact with
- Double-click the tab to restore the panel at 100% opacity
- Opacity mode uses a distinct cyan `OP 100%` display
- Normal token-left mode stays as `C 97%`
- Session / Weekly display based on CodexBarCLI usage output
- Bars change from cyan to yellow, then red as remaining usage gets low

### Requirements

- macOS 14 or newer
- [CodexBar](https://github.com/steipete/CodexBar) installed at `/Applications/CodexBar.app`
- CodexBar configured so the `codex` provider works
- Swift toolchain if you want to build from source

If Swift tools are missing, install Xcode Command Line Tools first:

```bash
xcode-select --install
```

### Install

Clone this repository:

```bash
git clone https://github.com/AkiGarage/codex-usage-widget-public.git
cd codex-usage-widget-public
```

Build and verify the app:

```bash
./script/build_and_run.sh --verify
```

Install it into `/Applications`:

```bash
ditto dist/CodexUsageWidget.app /Applications/CodexUsageWidget.app
open -n /Applications/CodexUsageWidget.app
```

You should see a small floating tab such as `C 37%`.

### Usage

#### Launch

Open the app:

```bash
open -n /Applications/CodexUsageWidget.app
```

#### Show or hide the panel

Click the floating tab.

- First click: show the detailed panel
- Second click: hide the detailed panel

#### Move the tab

Drag the floating tab. The position is saved and reused next time.

#### Resize the panel

Drag a panel corner. The UI scales down with the panel, including fonts, spacing, bars, and markers.

#### Adjust opacity

Two-finger swipe over the detailed panel to adjust only the panel opacity.

While adjusting opacity, the display changes from the normal `C 97%` token-left display to a cyan `OP 80%` display. `OP` means opacity, and it intentionally uses a different label, color, font weight, and pill style so it is easy to tell apart from Codex usage.

#### Recover from a fully transparent panel

If the panel becomes too transparent to interact with, two-finger swipe on the floating tab. The tab itself stays fully visible, and only the panel opacity changes.

You can also double-click the tab to show the panel again at 100% opacity.

#### Refresh

Right-click or Control-click the floating tab, then choose `Refresh`.

#### Quit

Right-click or Control-click the floating tab, then choose `Quit Codex Usage Widget`.

If the menu is not available, quit from Terminal:

```bash
pkill -x CodexUsageWidget
```

### Launch at login

Use macOS Login Items:

1. Open System Settings
2. Open General
3. Open Login Items
4. Click `+`
5. Select `/Applications/CodexUsageWidget.app`

### Uninstall

Quit the app:

```bash
pkill -x CodexUsageWidget
```

Remove the app:

```bash
trash /Applications/CodexUsageWidget.app
```

If `trash` is not installed, move the app to Trash from Finder.

Remove saved position/settings:

```bash
defaults delete local.codex.CodexUsageWidget
```

Remove the cloned repository if you no longer need it:

```bash
trash ~/Dev/codex-usage-widget-public
```

### Troubleshooting

#### `CodexBarCLI not found`

Make sure CodexBar is installed:

```bash
ls /Applications/CodexBar.app/Contents/Helpers/CodexBarCLI
```

#### Usage does not update

Check CodexBarCLI directly:

```bash
/Applications/CodexBar.app/Contents/Helpers/CodexBarCLI usage --provider codex --no-color
```

If that fails, fix CodexBar or Codex login state first.

#### The tab appears in a strange place

Reset the saved position:

```bash
defaults delete local.codex.CodexUsageWidget
open -n /Applications/CodexUsageWidget.app
```

#### It does not appear in the Dock

That is intentional. The app runs as an accessory app so it does not add Dock or menu bar clutter.

### Relationship to CodexBar and license

This is a companion app for [steipete/CodexBar](https://github.com/steipete/CodexBar).

It is not a modified CodexBar build. It does not bundle CodexBar source code or binaries. It calls the installed `CodexBarCLI` to display usage information retrieved by CodexBar.

CodexBar is published under the [MIT License](https://github.com/steipete/CodexBar/blob/main/LICENSE). MIT is a permissive license that allows modification and redistribution under its conditions. This project keeps attribution explicit and avoids bundling CodexBar itself.

This repository is released under the MIT License in [LICENSE](LICENSE).

### Changelog

See [CHANGELOG.md](CHANGELOG.md).
