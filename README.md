# zshmgr

`zshmgr` は、Zsh用の簡単なパッケージマネージャーです。パッケージのインストール、アンインストール、アップデート、リスト表示が可能です。

## 対応OS

`zshmgr` は、以下のオペレーティングシステムで動作します：

- macOS
- Linux
- Windows（WSLを使用）

## インストール

### 依存関係

`zshmgr` は以下のコマンドに依存しています：

- `git`
- `jq`

これらのコマンドがインストールされていることを確認してください。

### インストール方法

### `install.sh` スクリプトをダウンロードして実行します：

```bash
curl -O https://raw.githubusercontent.com/fun117/zshmgr/main/install.sh
chmod +x install.sh
./install.sh
```

これで `zshmgr` がインストールされ、システム全体で利用可能になります。

### ドキュメント

詳しい使い方やデモパッケージの作成方法については、[Zshmgrドキュメントサイト](https://zshmgr.vercel.app) をご覧ください。

### ライセンス

このプロジェクトはMITライセンスの下で公開されています。詳細はLICENSEファイルを参照してください。