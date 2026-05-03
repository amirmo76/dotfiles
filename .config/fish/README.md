# fish

## Install fish

**Arch:**
```bash
sudo pacman -S fish
```

**Debian/Ubuntu/Mint:**
```bash
sudo apt install fish
```

### Set as default shell

```bash
chsh -s $(which fish)
```

## Deploy config

```bash
mkdir -p ~/.config/fish
cp -r ~/dotfiles/.config/fish/* ~/.config/fish/
```

## Bootstrap plugins

Installs fisher, all plugins, and configures tide prompt:

```bash
fish ~/.config/fish/install.fish
```

## Plugins

- **fisher** — plugin manager
- **fzf.fish** — fzf integration (file, history, process search)
- **tide** — prompt (Tokyo Night themed)
