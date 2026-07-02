# Neovim Configuration

My personal Neovim configuration based on Kickstart.nvim.

## Prerequisites 
### Linux
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
(Arch)
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

### macOS
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
# Neovim Keymaps

A collection of the default keymaps I use most often, along with a few custom mappings tailored to my workflow.

## Modes

| Key | Action |
|------|--------|
| `i` | Enter Insert mode |
| `v` | Enter Visual mode |
| `jj` | Return to Normal mode |

# Movement

## Character & Word

| Key | Action |
|------|--------|
| `h` | Move left |
| `j` | Move down |
| `k` | Move up |
| `l` | Move right |
| `w` | Jump to next word |
| `b` | Jump to previous word |

## Line Navigation

| Key | Action |
|------|--------|
| `0` | Beginning of line |
| `$` | End of line |

## File Navigation

| Key | Action |
|------|--------|
| `gg` | First line of file |
| `G` | Last line of file |

## Paragraph Navigation

| Key | Action |
|------|--------|
| `{` | Previous paragraph |
| `}` | Next paragraph |

# Editing

## Yank

| Key | Action |
|------|--------|
| `yy` | Yank current line |
| `yap` | Yank around paragraph |
| `[count]yk` | Yank `count` lines above |

## Delete

| Key | Action |
|------|--------|
| `dd` | Delete current line |
| `dap` | Delete around paragraph |
| `[count]dk` | Delete `count` lines above |

## Paste

| Key | Action |
|------|--------|
| `p` | Paste below |
| `P` | Paste above |

## Undo

| Key | Action |
|------|--------|
| `u` | Undo |

# Visual Mode

| Key | Action |
|------|--------|
| `v` | Start character selection |
| `V` | Start line selection |
| `<movement>` | Extend selection |

# Windows

| Key | Action |
|------|--------|
| `<leader>h` | Focus left window |
| `<leader>j` | Focus lower window |
| `<leader>k` | Focus upper window |
| `<leader>l` | Focus right window |

# Neo-tree

| Key | Action |
|------|--------|
| `<leader>e` | Toggle Neo-tree |
| `Enter` | Open file / Expand or collapse directory |
| `a` | Add file or directory (`/` suffix creates a directory) |
| `r` | Rename |
| `d` | Delete |
| `m` | Move |
| `.` | Toggle hidden files |
| `R` | Refresh tree |
| `Backspace` | Go to parent directory |

# Commands

| Command | Action |
|---------|--------|
| `:w` | Save |
| `:q` | Quit |
| `:wq` | Save and quit |
| `:q!` | Quit without saving |
| `:wa` | Save all files |
| `:qa` | Quit all windows |
| `:qa!` | Force quit all |
