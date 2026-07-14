# dotfiles

tmux + Neovim (LazyVim) + Ghostty setup for macOS.

## Install on a new machine

```sh
xcode-select --install                      # git
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"  # homebrew
git clone https://github.com/ak47hi/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

Then:

1. Open Ghostty (config is already linked).
2. `tmux`, then `C-a I` to install tmux plugins via TPM.
3. `nvim` — LazyVim bootstraps plugins and Mason installs LSP servers on first run.

## Layout

| Repo path   | Symlinked to        |
|-------------|---------------------|
| `tmux.conf` | `~/.tmux.conf`      |
| `nvim/`     | `~/.config/nvim`    |
| `ghostty/`  | `~/.config/ghostty` |
| `Brewfile`  | consumed by `brew bundle` |
| `zshrc.shared` | sourced from `~/.zshrc` (append-only; install.sh adds the source line, never replaces your zshrc) |
