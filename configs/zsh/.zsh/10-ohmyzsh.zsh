# =========================================
# Oh My Zsh 設定
# =========================================
if [ -d "$HOME/.oh-my-zsh" ]; then
  export ZSH="$HOME/.oh-my-zsh"

  ZSH_THEME="powerlevel10k/powerlevel10k"

  # 使用するプラグイン
  plugins=(
    git
    docker
    docker-compose
    rails
    zsh-autosuggestions
    zsh-syntax-highlighting
    z
    zsh-bat
    you-should-use
    copyfile
    copypath
  )

  source $ZSH/oh-my-zsh.sh
fi

# p10k のプロンプト設定を読み込む（未作成ならスキップ）
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
