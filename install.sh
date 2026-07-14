#!/usr/bin/env bash
# Symlink dotfiles into place. Idempotent; backs up existing real files to *.bak.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    mv "$dst" "$dst.bak"
    echo "backed up $dst -> $dst.bak"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "linked $dst -> $src"
}

link "$DOTFILES/tmux.conf" "$HOME/.tmux.conf"
link "$DOTFILES/nvim"      "$HOME/.config/nvim"
link "$DOTFILES/ghostty"   "$HOME/.config/ghostty"

# TPM (tmux plugin manager) — clone if missing
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  echo "installed TPM; run prefix+I inside tmux to install plugins"
fi

# Homebrew packages
if command -v brew >/dev/null 2>&1; then
  brew bundle --file="$DOTFILES/Brewfile" || true
else
  echo "homebrew not found; skipping Brewfile (install from https://brew.sh)"
fi

echo "done"
