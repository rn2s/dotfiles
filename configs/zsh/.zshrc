# ========================================
# p10kは使用しているzshのテーマ
# 最初にp10k(oh my zsh系)を入れないとバグる
# ========================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ========================================
# 機密情報（別ファイルから読み込み）
# ========================================
if [ -f ~/.secrets.env ]; then
  source ~/.secrets.env
fi

# ========================================
# モジュール読み込み
# ========================================
for config_file in ~/.zsh/*.zsh(N); do
  source "$config_file"
done

# ========================================
# プライベート設定の読み込み（オプション）
# ========================================
# dotfiles-th (Techouse固有設定) が存在する場合のみ読み込む
if [ -d "$HOME/dotfiles-th/.zsh" ]; then
  for config_file in $HOME/dotfiles-th/.zsh/*.zsh(N); do
    source "$config_file"
  done
fi

# ========================================
# Bitwarden SSH Agent
# ========================================
export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"

