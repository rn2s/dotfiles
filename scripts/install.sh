#!/bin/bash
set -euo pipefail

# Move to the dotfiles directory.
cd "$(dirname "$0")/.."

# Install software listed in Brewfile.
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed. Install Homebrew first." >&2
  exit 1
fi

brew bundle --file Brewfile --verbose

# Install Oh My Zsh if missing.
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
