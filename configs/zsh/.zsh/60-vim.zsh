# ============================================
# Vi-mode設定 (zsh-vi-mode プラグイン使用)
# ============================================
# zsh-vi-mode が自動管理するもの:
#   - vi モード有効化
#   - カーソル形状変化（ノーマル=ブロック、インサート=バー）
#   - テキストオブジェクト (ciw, di", ca( など)
#   - ビジュアルモード
#   - j/k での履歴移動

# Escキーの遅延を短縮（0.01秒）
export KEYTIMEOUT=1

# 起動時はインサートモード
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

# jj でインサートモード→ノーマルモード
ZVM_VI_INSERT_ESCAPE_BINDKEY=jj

# モードによってカーソルの色を変える
function zvm_after_select_vi_mode() {
  case $ZVM_MODE in
    $ZVM_MODE_NORMAL)  echo -ne '\e]12;#E06C75\a' ;;  # 赤: ノーマルモード
    $ZVM_MODE_INSERT)  echo -ne '\e]12;#98C379\a' ;;  # 緑: インサートモード
    $ZVM_MODE_VISUAL)  echo -ne '\e]12;#C678DD\a' ;;  # 紫: ビジュアルモード
  esac
}
