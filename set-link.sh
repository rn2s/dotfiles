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

# 先程抽出したすべてのディレクトリ名に基づいてstowによるリンクの展開を行う
for name in "${config_dirs[@]}"; do
  stow -d configs -t ~ "$name"
done
