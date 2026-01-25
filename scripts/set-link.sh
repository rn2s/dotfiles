#!/bin/bash
# スクリプトがある場所（dotfiles）に移動
cd "$(dirname "$0")/.."

# configsディレクトリ直下に保存されているディレクトリ名をすべて抽出する
config_dirs=()
for dir in configs/*; do
  if [ -d "$dir" ]; then
    config_dirs+=("$(basename "$dir")")
  fi
done

# 先程抽出したすべてのディレクトリ名に基づいてstowによるリンクの展開を行う
for name in "${config_dirs[@]}"; do
  conflicts=()
  symlink_parents=()
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

    parent="$target"
    while [ "$parent" != "$HOME" ] && [ "$parent" != "/" ]; do
      parent="$(dirname "$parent")"
      if [ -L "$parent" ]; then
        symlink_parents+=("$parent")
        parent="$HOME"
      fi
    done

    if [ "${#symlink_parents[@]}" -eq 0 ]; then
      conflicts+=("$target")
    fi
  done < <(find "configs/$name" \( -type f -o -type l \) | sed "s|^configs/$name/||")

  if [ "${#symlink_parents[@]}" -gt 0 ]; then
    mapfile -t uniq_symlink_parents < <(printf '%s\n' "${symlink_parents[@]}" | sort -u)
    printf 'symlinked parent directories detected for %s:\n' "$name"
    printf '  %s\n' "${uniq_symlink_parents[@]}"
    printf 'replace these symlinked directories? [y/N]: '
    read -r answer
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
      for target in "${uniq_symlink_parents[@]}"; do
        rm -f "$target"
      done
    else
      continue
    fi
  fi

  if [ "${#conflicts[@]}" -gt 0 ]; then
    mapfile -t uniq_conflicts < <(printf '%s\n' "${conflicts[@]}" | sort -u)
    printf 'remove existing files for %s:\n' "$name"
    printf '  %s\n' "${uniq_conflicts[@]}"
    for target in "${uniq_conflicts[@]}"; do
      rm -rf "$target"
    done
  fi

  stow -d configs -t ~ "$name"
done
