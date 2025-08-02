# Dotfiles

These are my personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). The goal is to keep my development environment consistent and easy to set up across different machines.

## Features

Configuration for:

- `zsh` shell
- `nvim` (Neovim)
- `starship` prompt
- `mise` version manager
- `lsd` (LS Deluxe)
- `btop` (modern resource monitor)
- `neofetch`
- `ghostty` terminal emulator
- `zed` code editor
- `oh-my-posh` (alternative prompt)

All configurations under `.config/` follow the XDG base directory spec and are organized modularly for use with GNU Stow.

## Getting Started

### 1. Install GNU Stow

#### macOS

```bash
brew install stow
```

#### Arch Linux

```bash
sudo pacman -S stow
```

#### Fedora

```bash
sudo dnf install stow
```

#### Ubuntu

```bash
sudo apt update
sudo apt install stow
```

---

### 2. Clone this repo

```bash
git clone https://github.com/thepixelboy/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 3. Stow what you need

Each directory is a self-contained module. Run:

```bash
stow <module>
```

For example:

```bash
stow zsh
stow nvim
stow starship
stow .config
```

> **Note:** `.config` is stowed as a whole to keep nested folders like `btop`, `lsd`, `ghostty`, etc., correctly symlinked to `~/.config`.

---

## Directory Structure

```
dotfiles/
├── .config/
│   ├── btop/
│   ├── ghostty/
│   ├── lsd/
│   ├── mise/
│   ├── neofetch/
│   ├── nvim/
│   ├── oh-my-posh/
│   ├── starship/
│   └── zed/
├── .zshrc
└── README.md
```
