# Neovim Configuration

A personal Neovim configuration built on top of [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), extended with LSP tooling, autoformatting, fuzzy finding, and file navigation via Harpoon.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Updating](#updating)
- [Project Structure](#project-structure)
- [Keymaps](#keymaps)
  - [Modes](#modes)
  - [Movement](#movement)
  - [Editing](#editing)
  - [Visual Mode](#visual-mode)
  - [Windows](#windows)
  - [Neo-tree](#neo-tree)
  - [Harpoon](#harpoon)
- [Commands](#commands)

---

## Prerequisites

### Linux (Debian / Ubuntu)

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

### Linux (Arch)

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

### Dependency Reference

| Dependency | Purpose | Required |
|---|---|---|
| `tree-sitter-cli` | Installing Treesitter parsers | Yes |
| `nodejs` / `npm` | Mason-installed language servers | Yes |
| `ripgrep` / `fd` | Telescope live grep and file search | Yes |
| `wl-clipboard` | System clipboard integration | Yes |
| JetBrains Mono Nerd Font | Icon rendering in UI plugins | Recommended |

---

## Installation

```sh
git clone https://github.com/SaliqBashir/Neovim ~/.config/nvim && nvim
```

On first launch, `lazy.nvim` and Mason will automatically install all plugins, Treesitter parsers, and language servers. This may take a minute — check progress with `:Lazy` and `:Mason`.

---

## Updating

```sh
cd ~/.config/nvim
git pull
```

Then inside Neovim:

```vim
:Lazy sync
:MasonUpdate
:TSUpdate
```

---

## Project Structure

```
.
├── init.lua                    -- Entry point: options, keymaps, plugin specs
├── lazy-lock.json               -- Pinned plugin versions
├── lua/
│   ├── custom/
│   │   └── plugins/
│   │       └── init.lua         -- User-added plugins (currently inactive; see note below)
│   └── kickstart/
│       ├── health.lua
│       └── plugins/
│           ├── autopairs.lua
│           ├── debug.lua
│           ├── gitsigns.lua
│           ├── indent_line.lua
│           ├── lint.lua
│           └── neo-tree.lua
├── doc/
└── README.md
```

> **Note:** `{ import = 'custom.plugins' }` is commented out in `init.lua` by default. Uncomment it to enable plugins declared under `lua/custom/plugins/`.

---

## Keymaps

### Modes

| Key | Action |
|---|---|
| `i` | Enter Insert mode |
| `v` | Enter Visual mode |
| `jj` | Return to Normal mode |

### Movement

**Character & Word**

| Key | Action |
|---|---|
| `h` / `j` / `k` / `l` | Left / Down / Up / Right |
| `w` | Jump to next word |
| `b` | Jump to previous word |

**Line Navigation**

| Key | Action |
|---|---|
| `0` | Beginning of line |
| `$` | End of line |

**File Navigation**

| Key | Action |
|---|---|
| `gg` | First line of file |
| `G` | Last line of file |

**Paragraph Navigation**

| Key | Action |
|---|---|
| `{` | Previous paragraph |
| `}` | Next paragraph |

### Editing

**Yank**

| Key | Action |
|---|---|
| `yy` | Yank current line |
| `yap` | Yank around paragraph |
| `[count]yk` | Yank `count` lines above |

**Delete**

| Key | Action |
|---|---|
| `dd` | Delete current line |
| `dap` | Delete around paragraph |
| `[count]dk` | Delete `count` lines above |

**Paste**

| Key | Action |
|---|---|
| `p` | Paste below |
| `P` | Paste above |

**Undo**

| Key | Action |
|---|---|
| `u` | Undo |

### Visual Mode

| Key | Action |
|---|---|
| `v` | Start character selection |
| `V` | Start line selection |
| `<movement>` | Extend selection |

### Windows

| Key | Action |
|---|---|
| `<leader>h` | Focus left window |
| `<leader>j` | Focus lower window |
| `<leader>k` | Focus upper window |
| `<leader>l` | Focus right window |

### Neo-tree

| Key | Action |
|---|---|
| `<leader>e` | Toggle Neo-tree |
| `Enter` | Open file / expand or collapse directory |
| `a` | Add file or directory (`/` suffix creates a directory) |
| `r` | Rename |
| `d` | Delete |
| `m` | Move |
| `.` | Toggle hidden files |
| `R` | Refresh tree |
| `Backspace` | Go to parent directory |

### Harpoon

Quick-access file list for jumping between actively edited files without a fuzzy finder.

| Key | Action |
|---|---|
| `<leader>a` | Add current file to Harpoon list |
| `<leader>r` | Toggle Harpoon quick menu |
| `<leader>1` | Jump to file 1 |
| `<leader>2` | Jump to file 2 |
| `<leader>3` | Jump to file 3 |
| `<leader>4` | Jump to file 4 |

---

## Commands

| Command | Action |
|---|---|
| `:w` | Save |
| `:q` | Quit |
| `:wq` | Save and quit |
| `:q!` | Quit without saving |
| `:wa` | Save all files |
| `:qa` | Quit all windows |
| `:qa!` | Force quit all |

---
