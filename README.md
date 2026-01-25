## Overview
- Brewfileに記載されたソフトウェアの一括インストール -> `make install`
- configsに保存された設定へのリンク作成 `make set-link`
- 上記2つをいっぺんに -> `make setup`
## Prerequisites
- Homebrew（`scripts/install.sh` 実行前に必要）
- GNU Stow（`scripts/set-link.sh` 実行前に必要）
- zsh / docker / docker-compose は別途インストール前提

## Setup
```sh
make install
make set-link
make setup
```

## Add or Update
- 新しいソフトを管理したい場合は `Brewfile` に追加
- 新しい設定は `configs/` に保存

## Structure
- `Brewfile`: brew管理したいソフトウェアの一覧
- `configs/`: stowでリンクする設定
- `scripts/`: installとset-linkの実行スクリプト
- `Makefile`: `install`/`set-link`/`setup`

## Troubleshooting
- `brew bundle` が遅い場合は `make install` 実行時のログを確認
- 既存ファイルの衝突は `scripts/set-link.sh` が削除確認を出す
