# Dotfiles

## Stow

Install stow:

**Arch:**
```bash
sudo pacman -S stow
```

**Debian/Ubuntu/Mint:**
```bash
sudo apt install stow
```

Clone and stow:

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
stow fish tmux nvim kitty
```

> If target files already exist, delete or back them up first — stow will refuse to overwrite.

To remove symlinks:
```bash
stow -D fish tmux nvim kitty
```

---

## fish

Install fish:

**Arch:**
```bash
sudo pacman -S fish
```

**Debian/Ubuntu/Mint:**
```bash
sudo apt install fish
```

Set as default shell:
```bash
chsh -s $(which fish)
```

After stowing, bootstrap plugins (fisher + all plugins + tide config):
```bash
fish ~/.config/fish/install.fish
```

---

## tmux

Install tmux:

**Arch:**
```bash
sudo pacman -S tmux
```

**Debian/Ubuntu/Mint:**
```bash
sudo apt install tmux
```

Install TPM:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

After stowing, open tmux and press `prefix + I` (`Ctrl+a` then `Shift+i`) to install plugins.

---

## nvim

Install neovim (v0.9+ recommended):

**Arch:**
```bash
sudo pacman -S neovim
```

**Debian/Ubuntu/Mint:**
```bash
sudo apt install neovim
```

Install tree-sitter CLI (required for parser compilation):
```bash
npm install -g tree-sitter-cli
```

After stowing, open nvim — lazy.nvim will auto-install all plugins on first launch.

---

## kitty

Install kitty:

**Arch:**
```bash
sudo pacman -S kitty
```

**Debian/Ubuntu/Mint:**
```bash
sudo apt install kitty
```

No extra steps after stowing.

---

## keyd

keyd is not available in most package managers — build from source:

```bash
git clone https://github.com/rvaiya/keyd
cd keyd && make && sudo make install
sudo systemctl enable keyd --now
```

Config must be copied manually (system path, not stowable):
```bash
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo systemctl restart keyd
```

Remaps: `capslock` → tap: `esc`, hold: `ctrl`. `esc` → `capslock`.
