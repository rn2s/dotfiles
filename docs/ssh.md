# SSH鍵の運用

## 鍵の構成

| ファイル | 用途 | 対応アカウント |
|---------|------|--------------|
| `~/.ssh/id_ed25519_sit` | 個人用（デフォルト） | bp21071@shibaura-it.ac.jp |
| `~/.ssh/id_ed25519_techouse` | 会社用（`techouse-inc` リポジトリのみ） | shuji.murase@techouse.jp |

## Gitの設定

### 基本方針

- **デフォルトは個人用**：`~/.gitconfig` に SIT 用設定を記載
- **`techouse-inc` のリポジトリのみ会社用**：remote URL に `techouse-inc` が含まれるリポジトリだけ `~/.gitconfig-techouse` を読み込む
- 条件付き include は `includeIf.hasconfig:remote.*.url` を使う。判定対象は `origin` に限らず、そのリポジトリに設定されている全 remote URL。

### `~/.gitconfig`（dotfiles管理）

```gitconfig
# デフォルト設定（個人用）
[core]
    sshCommand = ssh -i ~/.ssh/id_ed25519_sit -o IdentitiesOnly=yes -F /dev/null

[user]
    name = shujimurase
    email = bp21071@shibaura-it.ac.jp
    signingkey = ~/.ssh/id_ed25519_sit.pub

[gpg]
    format = ssh
[commit]
    gpgsign = true

# techouse-inc のリポジトリのみ会社用設定を使用（必ず末尾に置く）
[includeIf "hasconfig:remote.*.url:git@github.com:techouse-inc/**"]
    path = ~/.gitconfig-techouse
[includeIf "hasconfig:remote.*.url:ssh://git@github.com/techouse-inc/**"]
    path = ~/.gitconfig-techouse
[includeIf "hasconfig:remote.*.url:https://github.com/techouse-inc/**"]
    path = ~/.gitconfig-techouse
```

### `~/.gitconfig-techouse`（dotfiles管理）

```gitconfig
[core]
    sshCommand = ssh -i ~/.ssh/id_ed25519_techouse -o IdentitiesOnly=yes -F /dev/null

[user]
    name = shujimurase
    email = shuji.murase@techouse.jp
    signingkey = ~/.ssh/id_ed25519_techouse.pub
```

このファイルは `configs/git/.gitconfig-techouse` として dotfiles で管理し、`scripts/set-link.sh` で `~/.gitconfig-techouse` にリンクする。

## SSH / SSH Agent の考え方

- Git の鍵選択は `core.sshCommand` で明示する。`-F /dev/null` を付けているため、Git 実行時は `~/.ssh/config` の Host 設定を読まない。
- SSH agent は「秘密鍵のパスフレーズ入力を省略する」「SSH 署名鍵を使う」ために使う。鍵選択そのものは `core.sshCommand` 側で決める。
- Bitwarden SSH Agent は使わない。

`~/.ssh/config` で `github.com` を `ssh.github.com:443` に逃がす設定を使いたい場合は、`core.sshCommand` の `-F /dev/null` を外すか、`sshCommand` 側に HostName/Port を明示する。

## 新しいマシンのセットアップ手順

### 1. 鍵ファイルの配置

```zsh
# 鍵ファイルを ~/.ssh/ に配置（パーミッション設定も忘れずに）
chmod 600 ~/.ssh/id_ed25519_techouse
chmod 600 ~/.ssh/id_ed25519_sit
```

### 2. dotfiles の Git 設定をリンク

```zsh
cd ~/dotfiles
./scripts/set-link.sh
```

`~/.gitconfig` と `~/.gitconfig-techouse` が作られることを確認する。

### 3. 必要なら SSH Agent に鍵を登録

```zsh
ssh-add ~/.ssh/id_ed25519_sit
ssh-add ~/.ssh/id_ed25519_techouse

# 登録確認
ssh-add -l
```

macOS で Keychain を使うなら `ssh-add --apple-use-keychain ...` を使う。Linux では通常の `ssh-add` でよい。

### 4. 動作確認

```zsh
# 通常リポジトリでは SIT 設定
cd ~/dotfiles
git config user.email   # => bp21071@shibaura-it.ac.jp
git config core.sshCommand

# techouse-inc リポジトリでは techouse 設定
cd ~/work/CHCentral
git remote -v           # techouse-inc/CHCentral を指していること
git config user.email   # => shuji.murase@techouse.jp
git config core.sshCommand
```

認証そのものを確認したい場合は、`GIT_SSH_COMMAND` で対象鍵を明示して確認する。

```zsh
GIT_SSH_COMMAND='ssh -i ~/.ssh/id_ed25519_sit -o IdentitiesOnly=yes -F /dev/null' \
  git ls-remote git@github.com:rn2s/dotfiles.git >/dev/null

GIT_SSH_COMMAND='ssh -i ~/.ssh/id_ed25519_techouse -o IdentitiesOnly=yes -F /dev/null' \
  git ls-remote git@github.com:techouse-inc/CHCentral.git >/dev/null
```

### 5. GitHubへの署名鍵の登録

コミット署名（`gpgsign = true`）が機能するには、各 GitHub アカウントに公開鍵を「Signing key」として登録する必要がある。

- 会社GitHubアカウント → `id_ed25519_techouse.pub` を Signing key として登録
- 個人GitHubアカウント → `id_ed25519_sit.pub` を Signing key として登録

## トラブルシューティング

### コミット署名が失敗する

SSH agent に鍵が登録されていない可能性が高い。

```zsh
ssh-add -l  # "The agent has no identities." が表示されたら未登録
ssh-add ~/.ssh/id_ed25519_sit
ssh-add ~/.ssh/id_ed25519_techouse
```

### `techouse-inc` リポジトリで会社メールが使われない

remote URL が `techouse-inc` を含む形になっているか確認する。`includeIf.hasconfig:remote.*.url` は remote URL を条件にしているため、remote が未設定のリポジトリでは会社用設定に切り替わらない。

```zsh
git remote -v
git config --show-origin --get-all user.email
git config --show-origin --get-all core.sshCommand
```

### git push が Permission denied になる

どの鍵で接続しているかを固定して確認する。

```zsh
GIT_SSH_COMMAND='ssh -i ~/.ssh/id_ed25519_sit -o IdentitiesOnly=yes -F /dev/null' \
  git ls-remote git@github.com:rn2s/dotfiles.git

GIT_SSH_COMMAND='ssh -i ~/.ssh/id_ed25519_techouse -o IdentitiesOnly=yes -F /dev/null' \
  git ls-remote git@github.com:techouse-inc/CHCentral.git
```

これが失敗するなら、対象 GitHub アカウントに対応する `*.pub` が Authentication key として登録されているか確認する。
