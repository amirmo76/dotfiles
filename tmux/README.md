# tmux

## Installation

### Install TPM

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Deploy config

```bash
mkdir -p ~/.config/tmux
cp ~/dotfiles/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf
```

### Install plugins

Start tmux, then press `prefix + I` (`Ctrl+a` then `Shift+i`) to install plugins.

## Plugins

- **tpm** — plugin manager
- **tmux-sensible** — sane defaults
- **vim-tmux-navigator** — seamless vim/tmux pane switching
- **tokyo-night-tmux** — status bar theme
- **tmux-yank** — system clipboard integration

## Install tmux

**Arch:**
```bash
sudo pacman -S tmux
```

**Debian/Ubuntu/Mint:**
```bash
sudo apt install tmux
```
