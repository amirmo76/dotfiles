# keyd

Remaps `capslock` → tap: `esc`, hold: `ctrl`. Also swaps `esc` → `capslock`.

## Installation

keyd is not in most package managers — build from source:

```bash
git clone https://github.com/rvaiya/keyd
cd keyd && make && sudo make install
```

### Enable service

```bash
sudo systemctl enable keyd --now
```

### Deploy config

```bash
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo systemctl restart keyd
```
