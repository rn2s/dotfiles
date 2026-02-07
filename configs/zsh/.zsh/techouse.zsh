# ========================================
# Techouse 固有設定
# rbenv / AWS / プロジェクト設定
# ========================================

# ========================================
# rbenv (Ruby version management)
# ========================================
if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init - zsh)"
fi

# ========================================
# AWS設定
# ========================================
# AWS SSO認証
alias bedrock='aws sso login --profile bedrock'

# ========================================
# Techouse プロジェクト設定
# CHWorkforce / CHCentral 関連
# ========================================

# ディレクトリ定義
export CHW_DIR="$HOME/workspace/CHWorkforce"
export CHC_DIR="$HOME/workspace/CHCentral"

# ディレクトリ移動
alias chc='cd "$CHC_DIR"'
alias chw='cd "$CHW_DIR"'

# SSH
alias sshneptune='autossh -M 0 chw-int-neptune'

# プロジェクト起動・停止
alias chuw='tmux kill-session -t chw 2>/dev/null ; echo "$CHW_DIR" ; cd "$CHW_DIR" && make up-all && tmuxinator chw'
alias chuc='tmux kill-session -t chc 2>/dev/null ; tmux kill-session -t chw 2>/dev/null ; cd "$CHC_DIR" && dcdu && tmuxinator start chc --no-attach && cd "$CHW_DIR" && make up-all && tmuxinator start chw && tmux attach -t chw'
alias chdw='tmux kill-session -t chw 2>/dev/null ; cd "$CHW_DIR" && make down'
alias chdc='tmux kill-session -t chw 2>/dev/null ; tmux kill-session -t chc 2>/dev/null ; cd "$CHW_DIR" && make down ; cd "$CHC_DIR" && dc down'

# その他
alias keen="cd ~/workspace/KeenDemo && docker compose up -d && cd ~/workspace/CHWorkforce"

# ========================================
# 機密情報は ~/.secrets.env に移動してください
# ========================================
# 以下のような内容を ~/.secrets.env に記載：
# export BUNDLE_GITHUB__COM=github_pat_..
export PATH=$HOME/.nodebrew/current/bin:$PATH
