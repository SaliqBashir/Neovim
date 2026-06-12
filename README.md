# Neovim Configuration

My personal Neovim configuration based on Kickstart.nvim.

## Prerequisites

### Linux (Arch / EndeavourOS)

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

Required:

* `tree-sitter-cli` for Treesitter parser installation
* `nodejs` and `npm` for Mason-installed language servers such as HTML and CSS LSPs
* `ripgrep` and `fd` for Telescope
* `wl-clipboard` for system clipboard support

Optional:

* JetBrains Mono Nerd Font (recommended)

### macOS

```sh
brew install \
  neovim git gh \
  ripgrep fd \
  tree-sitter tree-sitter-cli \
  node npm \
  python
```

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
