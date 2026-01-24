#!/bin/bash
# スクリプトがある場所（dotfiles）に移動
cd "$(dirname "$0")"

# configsディレクトリ直下に保存されているディレクトリ名をすべて抽出する
config_dirs=()
for dir in configs/*; do
  if [ -d "$dir" ]; then
    config_dirs+=("$(basename "$dir")")
  fi
done

# dotfiles配下への誤削除を防ぐため、リポジトリの実パスを保持
repo_root="$(pwd -P)"

# 先程抽出したすべてのディレクトリ名に基づいてstowによるリンクの展開を行う
for name in "${config_dirs[@]}"; do
  conflicts=()
  internal_conflicts=()
  while IFS= read -r relpath; do
    target="$HOME/$relpath"
    expected="$PWD/configs/$name/$relpath"

    if [ -L "$target" ]; then
      if [ "$(readlink -f "$target")" = "$expected" ]; then
        continue
      fi
    elif [ ! -e "$target" ]; then
      continue
    fi

    target_real="$(readlink -f "$target" 2>/dev/null || true)"
    if [ -n "$target_real" ] && [[ "$target_real" == "$repo_root/"* ]]; then
      internal_conflicts+=("$target -> $target_real")
      continue
    fi

    conflicts+=("$target")
  done < <(find "configs/$name" \( -type f -o -type l \) | sed "s|^configs/$name/||")

  if [ "${#internal_conflicts[@]}" -gt 0 ]; then
    printf 'skip %s: targets resolve inside dotfiles (likely a symlinked parent)\n' "$name"
    printf '  %s\n' "${internal_conflicts[@]}"
    continue
  fi

  if [ "${#conflicts[@]}" -gt 0 ]; then
    printf 'conflicts detected for %s:\n' "$name"
    printf '  %s\n' "${conflicts[@]}"
    printf 'overwrite existing files? [y/N]: '
    read -r answer
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
      for target in "${conflicts[@]}"; do
        rm -rf "$target"
      done
    else
      continue
    fi
  fi

  stow -d configs -t ~ "$name"
done
