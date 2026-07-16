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
link "$DOTFILES/markdownlint.yaml" "$HOME/.markdownlint.yaml"

# zsh: append-only — source the shared config from ~/.zshrc, never replace it
if ! grep -qF "dotfiles/zshrc.shared" "$HOME/.zshrc" 2>/dev/null; then
  printf '\n# shared dotfiles zsh config\nsource "%s/zshrc.shared"\n' "$DOTFILES" >> "$HOME/.zshrc"
  echo "appended zshrc.shared source line to ~/.zshrc"
fi

# TPM (tmux plugin manager) — clone if missing, then install plugins
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
"$HOME/.tmux/plugins/tpm/bin/install_plugins" || echo "WARNING: tmux plugin install failed; run C-a I inside tmux"

# Homebrew packages
if command -v brew >/dev/null 2>&1; then
  brew bundle --file="$DOTFILES/Brewfile" \
    || echo "WARNING: some Brewfile packages failed to install; run 'brew bundle check --file=$DOTFILES/Brewfile --verbose' to see which"
else
  echo "homebrew not found; skipping Brewfile (install from https://brew.sh)"
fi

# mermaid-cli renders via puppeteer, which needs a one-time headless-chrome download
if command -v mmdc >/dev/null 2>&1 && [ ! -d "$HOME/.cache/puppeteer/chrome-headless-shell" ]; then
  npx -y puppeteer browsers install chrome-headless-shell \
    || echo "WARNING: headless chrome download failed; mermaid rendering in nvim won't work until you run: npx puppeteer browsers install chrome-headless-shell"
fi

echo "done"
