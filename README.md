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
stow fish nvim claude
stow --no-folding tmux kitty herdr codex
```

> If target files already exist, delete or back them up first — stow refuses to
> overwrite anything it does not own. `~/.config/fish` in particular keeps
> fisher plugin artifacts alongside the tracked files, so remove only the
> tracked names (`config.fish`, `fish_plugins`, `install.fish`,
> `conf.d/tokyo_night.fish`, `functions/proxy.fish`) rather than the directory.

To remove symlinks:
```bash
stow -D fish tmux nvim kitty herdr claude codex
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

`herdr-layout` (function) creates a herdr workspace in the current directory
with the standard 4-pane layout and focuses it; `herdr-layout --apps` also
launches claude and nvim in it. Run from outside herdr, it attaches too.

After stowing, bootstrap plugins (fisher + all plugins + tide config):
```bash
fish ~/.config/fish/install.fish
```

---

## tmux

Config lives at `~/.config/tmux/tmux.conf` (not the legacy `~/.tmux.conf` —
delete that file if it exists, it takes precedence).

Plugins are managed by TPM, which installs into `~/.tmux/plugins` and is not
tracked here. On a fresh machine:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

then start tmux and press `prefix + I` to install the rest.


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

---

## herdr

Terminal workspace manager for AI coding agents. Binary lives at
`~/.local/bin/herdr`; it self-updates with `herdr update`.

Config path is the same on Linux and macOS: `~/.config/herdr/config.toml`.

Stow it with `--no-folding` — herdr writes logs, sockets and `session.json`
into `~/.config/herdr/`, and without that flag stow symlinks the whole
directory and that runtime junk lands in this repo:

```bash
stow --no-folding herdr
```

After editing the config:
```bash
herdr config check          # validate
herdr server reload-config  # apply to a running server
```

### vim-herdr-navigation

`Ctrl+h/j/k/l` moves between Neovim splits and herdr panes as one. The herdr
side is a plugin, installed outside this repo:

```bash
herdr plugin install paulbkim-dev/vim-herdr-navigation --yes
herdr plugin action list --plugin vim-herdr-navigation   # verify
```

The `[[keys.command]]` bindings are in `config.toml` here. The Neovim side is
picked up by `lua/plugins/vim-tmux-navigator.lua`, which globs the installed
plugin's `editor/nvim.lua`; without the plugin the keys fall back to plain
`wincmd`, so the nvim config stays portable. Needs `jq`.

---

## claude

Claude Code skills, linked into `~/.claude/skills`.

```
claude/.claude/skills/
├── assistant/
├── caveman/
├── commit/
├── svg-anim/
└── teacher/
```

`~/.claude` holds untracked runtime state (credentials, history, projects), so
only `skills` is stowed — stow folds it into a single symlink. Adding a skill
means creating it in this repo, not in `~/.claude/skills`.

No extra steps after stowing; Claude Code picks the skills up on next launch.

---

## codex

The same skills, for Codex CLI at `~/.codex/skills/skills`.

```
codex/.codex/skills/skills -> ../../../claude/.claude/skills
```

It is a symlink to the `claude` package, so there is one copy of every skill —
edit it under `claude/.claude/skills/` and both agents see the change.

`~/.codex` holds runtime state and `~/.codex/skills/.system` holds Codex's own
built-in skills, so stow with `--no-folding` to keep those directories real:

```bash
stow --no-folding codex
```

If `~/.codex/skills/skills` already exists as a real directory, delete it first.
