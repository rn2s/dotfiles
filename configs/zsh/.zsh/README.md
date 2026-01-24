# Zsh 設定ガイド

このディレクトリには、モジュール化された zsh 設定ファイルが含まれています。

## 📁 ファイル構成

```
~/.zshrc                      # メイン設定ファイル（各モジュールを読み込む）
~/.zsh/
  ├── README.md               # このファイル
  ├── aliases.zsh             # 基本的なエイリアス
  ├── docker.zsh              # Docker/Rails関連コマンド
  ├── functions.zsh           # カスタム関数（memo など）
  ├── vim-mode.zsh            # Vi-mode設定
  ├── claude.zsh              # Claude Code + Tmux統合
  └── zshrc-utils.zsh         # 設定管理ユーティリティ
```

## 🚀 基本コマンド

### 設定ファイルの編集

```bash
# fzf でファイルを選択して編集（プレビュー付き）
ez

# または個別エイリアスで直接開く
ezm             # ~/.zshrc（メイン設定）
eza             # aliases.zsh
ezd             # docker.zsh
ezf             # functions.zsh
ezv             # vim-mode.zsh
ezc             # claude.zsh
ezu             # zshrc-utils.zsh
ezall           # 全てのファイルを開く
```

### 設定のリロード

```bash
rz              # source ~/.zshrc（全モジュールを再読み込み）
```

## 🤖 Claude Code + Tmux

### Claude Code を起動

```bash
# 新しいセッションを作成（セッション名は自動生成）
claude

# セッション名を指定して作成
claude my-project
claude api-work
claude frontend-dev
```

### 既存セッションに接続

```bash
# fzf でセッションを選択（プレビュー付き）
claude-attach
ca              # 短縮形

# セッション一覧を表示
cls
```

### Tmux 基本操作

```bash
# セッションからデタッチ（切断）
Ctrl+b, d

# セッション一覧
tmux list-sessions
tmux ls

# 特定のセッションに直接接続
tmux attach -t claude-my-project
```

### 実際の使用例

```bash
# 1. API開発用のセッションを作成
claude api-development
# → tmux セッション内で Claude Code が起動

# 作業中...
# Ctrl+b, d でデタッチ

# 2. フロントエンド開発用のセッションを作成
claude frontend-work
# → 別のセッション内で Claude Code が起動

# 3. 後で API開発セッションに戻る
ca
# → fzf でセッションを選択
# → 最後の50行がプレビュー表示される
# → Enter で接続
```

## 🔍 fzf（ファジー検索）

### キーバインド

```bash
Ctrl+T          # カレントディレクトリ以下のファイルを検索
Ctrl+R          # コマンド履歴を検索
Alt+C           # ディレクトリを検索して移動
```

### 検索構文

```bash
# 前方一致
^music

# 後方一致
.mp3$

# 完全一致
'wild

# OR検索
mp3 | mp4

# AND検索（スペース区切り）
music .mp3

# NOT検索
!.mp4
```

### fzf の操作方法

- **矢印キー / Ctrl+j/k**: 上下移動
- **Enter**: 選択して確定
- **Esc / Ctrl+c**: キャンセル
- **Tab**: 複数選択（マルチセレクトモード時）

## 📝 メモ管理

```bash
# 引数なし：memoディレクトリでnvimを開く
memo

# 名前付きメモ
memo work           # ~/memo/work.txt
memo ideas          # ~/memo/ideas.txt

# 日付付きメモ
memo -d             # ~/memo/2025-11-14.txt
memo --date         # 同上

# memoディレクトリへ移動
cd memo
```

## 🐋 Docker関連

```bash
# Docker Compose
dc              # docker compose
dcud            # docker compose up -d
dcdu            # docker compose down && up -d

# Rails（Docker経由）
dap             # docker attach（Pumaに接続）
dr              # docker compose exec puma bundle exec rails
dmb             # マイグレーション実行
bers            # RSpec実行
```

## 🏢 プロジェクト管理

プロジェクト固有の設定やコマンドは `dotfiles-th` リポジトリで管理しています。

## ⌨️ Vi-mode

zsh は Vi-mode が有効になっています。

### モード

- **インサートモード**: 通常の入力モード（バーカーソル）
- **ノーマルモード**: Vim風の操作モード（ブロックカーソル）

### キーバインド

#### インサートモード
```bash
Esc             # ノーマルモードへ切り替え
Ctrl+A          # 行頭へ移動
Ctrl+E          # 行末へ移動
Ctrl+F          # 右へ1文字
Ctrl+B          # 左へ1文字
Ctrl+D          # カーソル位置の文字を削除
Ctrl+K          # カーソルから行末まで削除
Ctrl+W          # 単語削除
Ctrl+U          # カーソルから行頭まで削除
Ctrl+R          # 履歴検索（fzf）
Ctrl+P/N        # 前/次のコマンド
```

#### ノーマルモード
```bash
i               # インサートモードへ
h/j/k/l         # 左/下/上/右
0/$             # 行頭/行末
w/b             # 次/前の単語
dd              # 行削除
cc              # 行削除してインサートモード
```

## 🎨 その他のエイリアス

```bash
vim             # nvim
vi              # nvim
```

## 🔧 トラブルシューティング

### 設定が反映されない

```bash
# 設定をリロード
rz

# または新しいシェルを起動
exec zsh
```

### コマンドが見つからない

```bash
# コマンドの定義場所を確認
type <command>

# 例
type ez
type claude
type ca
```

### fzf が動かない

```bash
# fzf がインストールされているか確認
which fzf

# インストールされていない場合
brew install fzf
$(brew --prefix)/opt/fzf/install
```

### tmux セッションが残っている

```bash
# 全セッション一覧
tmux ls

# 特定のセッションを終了
tmux kill-session -t <session-name>

# 全セッションを終了（注意！）
tmux kill-server
```

### Claude セッションだけを一覧表示

```bash
cls             # claude- で始まるセッションのみ表示
```

## 📚 参考リンク

- [fzf - GitHub](https://github.com/junegunn/fzf)
- [bat - GitHub](https://github.com/sharkdp/bat)
- [tmux - GitHub](https://github.com/tmux/tmux)
- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)

## 💡 Tips

### Claude Code セッションの命名規則

目的別にセッション名をつけると管理しやすい：

```bash
claude api          # API開発
claude frontend     # フロントエンド
claude bugfix       # バグ修正
claude refactor     # リファクタリング
claude review       # コードレビュー
```

### fzf プレビューの活用

`ez` コマンドでは、ファイルを選択する前に内容をプレビューできます。
矢印キーで移動しながら、どのファイルを編集すべきか確認できます。

### tmux セッションのデタッチ癖

長時間作業する場合は、`Ctrl+b, d` でデタッチする癖をつけると、
ターミナルを誤って閉じても作業が失われません。

### 複数プロジェクトの並行作業

```bash
# プロジェクトA
claude project-a

# デタッチ (Ctrl+b, d)

# プロジェクトB
claude project-b

# 後で ca で各セッションを行き来
```

---

**最終更新**: 2025-11-14
