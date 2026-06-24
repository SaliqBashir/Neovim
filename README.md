# Neovim Configuration

My personal Neovim configuration based on Kickstart.nvim.

## Prerequisites Linux
(Debian / Ubuntu)

```sh
sudo apt update

sudo apt install -y \
  neovim git gh \
  build-essential unzip curl \
  ripgrep fd-find \
  tree-sitter-cli \
  nodejs npm \
  python3 python3-pip python3-venv \
  wl-clipboard
```
(Arch / EndeavourOS)
```sh
sudo pacman -S --needed \
  neovim git github-cli \
  gcc make unzip \
  ripgrep fd \
  tree-sitter tree-sitter-cli \
  nodejs npm \
  python python-pip \
  wl-clipboard
```

## macOS
```sh
brew install \
  neovim git gh \
  ripgrep fd \
  tree-sitter tree-sitter-cli \
  node npm \
  python
```
Required:

* `tree-sitter-cli` for Treesitter parser installation
* `nodejs` and `npm` for Mason-installed language servers
* `ripgrep` and `fd` for Telescope
* `wl-clipboard` for system clipboard integration

Optional:

* JetBrains Mono Nerd Font (recommended)

## Installation

```sh
git clone https://github.com/SaliqBashir/Neovim ~/.config/nvim && nvim
```

On first launch, Lazy.nvim and Mason will automatically install plugins, Treesitter parsers, and language servers.

## Updating

```sh
cd ~/.config/nvim
git pull
```

Inside Neovim:

```vim
:Lazy sync
:MasonUpdate
:TSUpdate
```
