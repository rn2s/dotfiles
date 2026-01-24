# ========================================
# メモ管理
# ========================================
export MEMO_DIR="$HOME/memo"
mkdir -p "$MEMO_DIR"

# cd memoでどこからでもmemoディレクトリに移動できるように
export CDPATH=".:$HOME"

function memo() {

  if [[ "$1" == "-d" ]] || [[ "$1" == "--date" ]]; then
    # 日付付きメモ
    nvim "$MEMO_DIR/$(date +%Y-%m-%d).txt"
  elif [[ -z "$1" ]]; then
    # 引数なし：ファイル名未確定でnvimを開く
    cd "$MEMO_DIR" && nvim
  else
    # その他：指定した名前のメモ
    nvim "$MEMO_DIR/$1.txt"
  fi
}
