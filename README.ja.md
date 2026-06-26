# Codex Usage Nano

[English](README.md) | 日本語

Codex Usage Nano は、Codex の使用量をすぐ見るための小さな macOS アプリです。CodexBar に入っているローカルコマンド `CodexBarCLI` を使って動きます。

MacBook のノッチ周りでメニューバー項目が見づらい人や、Codex の残り使用量を作業中にすぐ確認したい人向けです。

## プレビュー

<table>
  <tr>
    <td align="center"><strong>ホバーで残量表示</strong></td>
    <td align="center"><strong>ドラッグと詳細パネル</strong></td>
  </tr>
  <tr>
    <td><img src="screenshots/codex-usage-nano-demo-hover.gif" alt="最小タブにマウスを乗せるとセッション残量が表示される様子" width="380"></td>
    <td><img src="screenshots/codex-usage-nano-demo-panel.gif" alt="フローティングタブをドラッグして詳細パネルを開く様子" width="380"></td>
  </tr>
</table>

<table>
  <tr>
    <td align="center"><strong>最小タブ</strong></td>
    <td align="center"><strong>ホバー</strong></td>
    <td align="center"><strong>ホバー + 詳細パネル</strong></td>
    <td align="center"><strong>詳細パネル</strong></td>
  </tr>
  <tr>
    <td><img src="screenshots/codex-usage-nano-collapsed.png" alt="セッションと週次のバーだけを表示する最小タブ" width="210"></td>
    <td><img src="screenshots/codex-usage-nano-hover.png" alt="ホバー中にセッション残量を表示しているタブ" width="210"></td>
    <td><img src="screenshots/codex-usage-nano-hover-panel.png" alt="詳細パネルを開いたままホバーしているタブ" width="210"></td>
    <td><img src="screenshots/codex-usage-nano-panel.png" alt="Codex Usage Nano の詳細パネル" width="210"></td>
  </tr>
</table>

## なぜ作ったか

メニューバーの使用量表示は、忙しい画面だと見落としやすく、ノッチ付き MacBook では場所によって隠れたり見づらくなったりします。

Codex Usage Nano は、メニューバーではなく小さなフローティングタブとして表示されます。見やすい場所に置いて、ホバーでセッション残量を見たり、クリックで詳細パネルを開いたりできます。

## 機能

- セッションと週次のバーを表示するフローティングタブ
- ホバーでセッション残量のパーセントを表示
- クリックで詳細パネルを開閉
- 好きな場所へドラッグでき、位置を保存
- 詳細パネルの移動とサイズ変更
- 自動更新とタブメニューからの手動更新
- ローカルの CodexBarCLI で使用量を取得し、起動中も Dock とメニューバーを増やさない

## 必要なもの

- macOS 14 以降
- `/Applications/CodexBar.app` にインストールされた CodexBar
- CodexBar の `codex` provider が設定済み
- ソースからビルドする場合のみ Swift toolchain

Codex Usage Nano の実行中に CodexBar アプリを開いておく必要はありません。インストール済みの `CodexBarCLI` を直接呼び出します。

## インストール

### リリース版を使う

[GitHub Releases](https://github.com/AkiGarage/codex-usage-nano/releases/latest) から最新の `CodexUsageNano-*-macos.zip` をダウンロードし、展開して `CodexUsageNano.app` を `/Applications` に移動します。

そのあと起動します。

```bash
open -n /Applications/CodexUsageNano.app
```

macOS が未確認アプリとして警告する場合は、System Settings > Privacy & Security から `CodexUsageNano.app` の実行を許可します。

### ソースからビルド

```bash
git clone https://github.com/AkiGarage/codex-usage-nano.git
cd codex-usage-nano
./script/build_and_run.sh --verify
ditto dist/CodexUsageNano.app /Applications/CodexUsageNano.app
open -n /Applications/CodexUsageNano.app
```

## 使い方

| 操作 | 方法 |
| --- | --- |
| 起動 | `/Applications` の `CodexUsageNano.app` を開きます。 |
| 詳細パネルを開く / 閉じる | フローティングタブをクリックします。 |
| タブを動かす | タブをドラッグします。位置は次回起動時にも使われます。 |
| 詳細パネルを動かす / サイズ変更する | パネルの背景をドラッグして移動し、端や角をドラッグしてサイズ変更します。 |
| 更新 | タブを右クリック、二本指タップ、または Control-click して `Refresh` を選びます。 |
| 透明度を調整 | 詳細パネルまたはタブ上で二本指スワイプします。タブをダブルクリックすると 100% に戻り、タブとパネルの位置関係も初期状態に戻ります。 |
| 終了 | タブメニューを使うか、`pkill -x CodexUsageNano` を実行します。 |

最小タブは、上のバーがセッション、下のバーが週次です。セッションは現在の 5 時間の Codex 使用枠、週次は週ごとの使用枠です。詳細パネルでは、リセット時刻、ペース、予測、大きめのバーを確認できます。

![Show Panel、Refresh、Quit を表示したタブメニュー](screenshots/tab-menu.png)

## プライバシー

- OpenAI token、cookie、password は保存しません。
- CodexBar 本体や実行ファイルは同梱しません。
- ローカルの `/Applications/CodexBar.app/Contents/Helpers/CodexBarCLI` を呼び出します。
- ローカル snapshot がある場合も、表示向けに整理された使用量データだけを含みます。
- 広い LAN に向けた未認証サーバーは公開しません。

ローカル snapshot は次の場所に書き込まれることがあります。

```text
~/Library/Application Support/CodexUsageNano/latest-usage-snapshot.json
/private/tmp/codex-usage-nano/latest-usage-snapshot.json
```

## トラブルシュート

### `CodexBarCLI not found`

CodexBar が `/Applications` に入っているか確認します。

```bash
ls /Applications/CodexBar.app/Contents/Helpers/CodexBarCLI
```

### 使用量が更新されない

CodexBarCLI だけで使用量を取得できるか確認します。

```bash
/Applications/CodexBar.app/Contents/Helpers/CodexBarCLI usage --provider codex --no-color
```

このコマンドが失敗する場合は、CodexBar を開いて `codex` provider の設定を確認してください。

### タブや詳細パネルが変な場所に出る

保存された位置と設定をリセットします。

```bash
defaults delete local.codex.CodexUsageNano
open -n /Applications/CodexUsageNano.app
```

### macOS にブロックされる

System Settings > Privacy & Security を開き、ブロックされた `CodexUsageNano.app` の実行を許可します。

## アンインストール

アプリを終了し、`CodexUsageNano.app` をゴミ箱に移動して、保存設定を削除します。

```bash
pkill -x CodexUsageNano
defaults delete local.codex.CodexUsageNano
```

## ライセンスと謝辞

MIT License です。詳しくは [LICENSE](LICENSE) を見てください。

Codex Usage Nano は [steipete/CodexBar](https://github.com/steipete/CodexBar) と一緒に使う連携アプリです。CodexBar も MIT License で公開されています。

変更履歴は [CHANGELOG.md](CHANGELOG.md) にあります。
