# ============================================
# Vi-mode設定
# ============================================

# vi-modeを有効化
bindkey -v

# Escキーの遅延を短縮（0.01秒）
export KEYTIMEOUT=1

# カーソル形状を変更（モードによって変える）
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'  # ブロックカーソル（ノーマルモード）
  else
    echo -ne '\e[5 q'  # バーカーソル（インサートモード）
  fi
}
function zle-line-init {
  echo -ne '\e[5 q'  # 起動時はインサートモード
}
function zle-line-finish {
  echo -ne '\e[5 q'  # コマンド実行後
}
zle -N zle-keymap-select
zle -N zle-line-init
zle -N zle-line-finish

# インサートモードでもEmacs風のキーバインドを併用
bindkey '^A' beginning-of-line      # Ctrl+A: 行頭
bindkey '^E' end-of-line            # Ctrl+E: 行末
bindkey '^F' forward-char           # Ctrl+F: 右へ1文字移動
bindkey '^B' backward-char          # Ctrl+B: 左へ1文字移動
bindkey '^D' delete-char            # Ctrl+D: カーソル位置の文字を削除
bindkey '^K' kill-line              # Ctrl+K: カーソルから行末まで削除
bindkey '^W' backward-kill-word     # Ctrl+W: 単語削除
bindkey '^U' backward-kill-line     # Ctrl+U: カーソルから行頭まで削除
bindkey '^R' history-incremental-search-backward  # Ctrl+R: 履歴検索
bindkey '^S' history-incremental-search-forward   # Ctrl+S: 前方履歴検索
bindkey '^P' up-line-or-history     # Ctrl+P: 前のコマンド
bindkey '^N' down-line-or-history   # Ctrl+N: 次のコマンド

# ノーマルモードでの追加操作
bindkey -M vicmd 'k' up-line-or-history
bindkey -M vicmd 'j' down-line-or-history

# 現在のモードを右プロンプトに表示（オプション）
 function vi_mode_prompt_info() {
   echo "${${KEYMAP/vicmd/[NORMAL]}/(main|viins)/[INSERT]}"
 }
 RPROMPT='$(vi_mode_prompt_info)'  # コメント解除で有効化
