# Neovim Configuration

A personal Neovim configuration built on [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim): native LSP, completion, Telescope, Neo-tree, Harpoon, a Gitsigns hunk workflow, and in-editor image rendering. Plugin versions are pinned, and one command installs everything.

```sh
curl -fsSL https://raw.githubusercontent.com/SaliqBashir/Neovim/main/install.sh | bash
```

---

## Table of Contents

- [Screenshots](#screenshots)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Updating](#updating)
- [Optional: Discord presence](#optional-discord-presence)
- [Project Structure](#project-structure)
- [Keymaps](#keymaps)
- [Commands](#commands)
- [License](#license)

---

## Screenshots

<table>
  <tr>
    <td width="50%">
      <strong>Editor Workspace</strong>
      <br/>
      <img src="https://cdn.saliqbashir.me/default_view.png" width="100%" />
      <br/>
      <sub>Neovim layout with Neo-tree.</sub>
    </td>
    <td width="50%">
      <strong>Telescope</strong>
      <br/>
      <img src="https://cdn.saliqbashir.me/telescope.png" width="100%" />
      <br/>
      <sub>Fuzzy file finding with live preview and project navigation.</sub>
    </td>
  </tr>
  <tr>
    <td width="50%">
      <strong>LSP Integration</strong>
      <br/>
      <img src="https://cdn.saliqbashir.me/lsp.png" width="100%" />
      <br/>
      <sub>Hover documentation, diagnostics and language intelligence.</sub>
    </td>
    <td width="50%">
      <strong>Which-key</strong>
      <br/>
      <img src="https://cdn.saliqbashir.me/menu.png" width="100%" />
      <br/>
      <sub>Discoverable keybindings and grouped shortcuts.</sub>
    </td>
  </tr>
  <tr>
    <td width="50%">
      <strong>Git Integration</strong>
      <br/>
      <img src="https://cdn.saliqbashir.me/git_hunk.png" width="100%" />
      <br/>
      <sub>Gitsigns hunk preview with inline change visualization.</sub>
    </td>
    <td width="50%">
      <strong>Inline Image Rendering</strong>
      <br/>
      <img src="https://cdn.saliqbashir.me/image.png" width="100%" />
      <br/>
      <sub>Image rendering directly inside Neovim using the Kitty graphics protocol.</sub>
    </td>
  </tr>
</table>

---

## Features

| Area | What's configured |
|---|---|
| Base | Kickstart.nvim and `lazy.nvim`, with plugin versions pinned in `lazy-lock.json` |
| Colorscheme | Gruvbox (hard contrast) |
| LSP | `nvim-lspconfig` + Mason: `clangd`, `pyright`, `ruff`, `ts_ls`, `html`, `cssls`, `emmet_language_server`, `lua_ls`; progress via `fidget.nvim` |
| Completion | `blink.cmp` + LuaSnip, with signature help |
| Syntax | Treesitter (`main` branch), parsers install automatically |
| Formatting | `conform.nvim`: `stylua` for Lua and Prettier for JS / TS / JSX / TSX (both installed by Mason). Prettier runs on save; `<leader>f` formats on demand, with LSP fallback |
| Linting | LSP diagnostics, plus `nvim-lint` running `markdownlint` on Markdown (installed by Mason) |
| Fuzzy finding | Telescope with `fzf-native` and `ui-select` |
| File tree | Neo-tree |
| File switching | Harpoon 2 |
| Git | Gitsigns, with hunk actions under `<leader>g` |
| Images | `image.nvim` (Kitty graphics backend, ImageMagick CLI processor) |
| Editing | `mini.ai`, `mini.surround`, autopairs, `nvim-ts-autotag`, `guess-indent`, indent guides |
| UI | `mini.statusline`, `which-key`, `todo-comments`, Nerd Font icons |
| Auto-save | Modified file buffers are written on `InsertLeave` and `TextChanged` |
| Extras | Cord (Discord Rich Presence), opt-in |

---

## Prerequisites

- **Platforms:** Debian / Ubuntu (`apt`), Arch (`pacman`), Fedora (`dnf`), macOS (Homebrew), and Windows via WSL.
- **Terminal:** one that implements the Kitty graphics protocol if you want inline images (Ghostty, Kitty, WezTerm).

| Dependency | Purpose | Installed by script |
|---|---|---|
| Neovim 0.11+ | Native LSP config, Treesitter `main` branch | Yes |
| `git`, `gh` | Cloning and updating the config | Yes |
| C compiler, `make` | Building Treesitter parsers and `telescope-fzf-native` | Yes |
| `tree-sitter-cli` | Installing Treesitter parsers | Yes |
| `nodejs`, `npm` | Mason-installed tools (Prettier, markdownlint, `ts_ls`, ...) | Yes |
| `python3`, `pip` | Python tooling | Yes |
| `ripgrep`, `fd` | Telescope live grep and file search | Yes |
| `wl-clipboard` | System clipboard integration (Linux) | Yes |
| `imagemagick` | Image conversion for `image.nvim` | Yes |
| JetBrains Mono Nerd Font | Icons in UI plugins | `--font` |

Language servers, formatters and linters (`stylua`, `prettier`, `markdownlint`, `ruff`, and the servers listed above) are installed by Mason, so you do not need to install them yourself.

---

## Installation

The script installs the prerequisites, clones this config to `~/.config/nvim` (`$XDG_CONFIG_HOME` is respected), and runs `:Lazy restore` headlessly so plugins land on the exact commits in `lazy-lock.json`. First launch may take a moment while Mason and Treesitter finish downloading tools and parsers.

```sh
curl -fsSL https://raw.githubusercontent.com/SaliqBashir/Neovim/main/install.sh | bash
```

With JetBrainsMono Nerd Font:

```sh
curl -fsSL https://raw.githubusercontent.com/SaliqBashir/Neovim/main/install.sh | bash -s -- --font
```

| Flag | Effect |
|---|---|
| `--font` | Also install JetBrainsMono Nerd Font |
| `--no-config` | Install prerequisites only; leave `~/.config/nvim` alone |
| `-v`, `--verbose` | Show full command output instead of one line per step |
| `-h`, `--help` | Show usage |

**Safety**

- Only missing packages are installed; nothing already installed is upgraded, except Neovim when it is older than 0.11.
- An existing `~/.config/nvim` is never overwritten. A previous clone of this repo is fast-forwarded (any local change to `lazy-lock.json` is discarded first); any other config is moved to `~/.config/nvim.bak.<timestamp>`.
- On Linux the script needs `sudo` (unless run as root). On macOS it needs Homebrew.

<details>
<summary><b>Manual install</b></summary>

Install the prerequisites above, then:

```sh
git clone https://github.com/SaliqBashir/Neovim ~/.config/nvim
nvim
```

`lazy.nvim` bootstraps itself on first launch and installs plugins at the commits recorded in `lazy-lock.json`.

</details>

---

## Updating

Re-running the installer updates an existing clone and re-syncs plugins to the lockfile. Or manually:

```sh
cd ~/.config/nvim
git checkout -- lazy-lock.json   # drop local lockfile changes so the pull can fast-forward
git pull
```

Then inside Neovim:

```vim
:Lazy restore
:MasonUpdate
:TSUpdate
```

`:Lazy restore` sets every plugin to the version in `lazy-lock.json`. To move plugins to their latest versions instead, run `:Lazy update`; that rewrites `lazy-lock.json` locally.

---

## Optional: Discord presence

[Cord](https://github.com/vyfor/cord.nvim) shows the file and workspace you are editing in Discord. Because that shares file names, it is **off by default**. To enable it, set `NVIM_DISCORD=1` in your environment:

```sh
export NVIM_DISCORD=1   # e.g. in ~/.zshrc or ~/.bashrc
```

---

## Project Structure

```
.
├── init.lua                    -- Entry point: options, keymaps, plugin specs
├── install.sh                  -- Bootstrap script
├── lazy-lock.json              -- Pinned plugin versions
├── lua/
│   ├── custom/
│   │   └── plugins/            -- User-added plugins (auto-imported)
│   │       ├── autotag.lua
│   │       ├── cord.lua
│   │       ├── gruvbox.lua
│   │       ├── harpoon.lua
│   │       ├── image.lua
│   │       └── init.lua
│   └── kickstart/
│       ├── health.lua
│       └── plugins/
│           ├── autopairs.lua
│           ├── debug.lua       -- Not enabled by default
│           ├── gitsigns.lua    -- Hunk keymaps (<leader>g)
│           ├── indent_line.lua
│           ├── lint.lua
│           └── neo-tree.lua
├── doc/
├── .stylua.toml
├── LICENSE.md
└── README.md
```

---

## Keymaps

`<leader>` is `Space`. Press it and wait: `which-key` lists everything available.

### General

| Key | Mode | Action |
|---|---|---|
| `jj` | Insert | Return to Normal mode |
| `i` | Normal | Remapped to `a` (insert after the cursor) |
| `<D-CR>` | Insert | Jump to end of line and keep typing (Cmd+Enter) |
| `t` | Normal | Redo |
| `<Esc>` | Normal | Clear search highlight |
| `<Esc><Esc>` | Terminal | Exit terminal mode |
| `<leader>h` / `j` / `k` / `l` | Normal | Focus left / lower / upper / right window |
| `<leader>f` | Normal / Visual | Format buffer |
| `<leader>q` | Normal | Diagnostics to location list |

Modified file buffers are written automatically on `InsertLeave` and `TextChanged`.

### Search (Telescope)

| Key | Action |
|---|---|
| `<leader>sf` | Find files |
| `<leader>sg` | Live grep |
| `<leader>sw` | Grep word under cursor / selection |
| `<leader>sd` | Diagnostics |
| `<leader>sr` | Resume last picker |
| `<leader>s.` | Recent files |
| `<leader>s/` | Live grep in open files |
| `<leader>sn` | Find Neovim config files |
| `<leader>sh` / `sk` / `sc` / `ss` | Help tags / keymaps / commands / pickers |
| `<leader>/` | Fuzzy search in current buffer |
| `<leader><leader>` | Open buffers |

### LSP

Active when a language server attaches to the buffer.

| Key | Action |
|---|---|
| `K` | Hover documentation |
| `grn` | Rename |
| `gra` | Code action (Normal / Visual) |
| `grd` | Go to definition |
| `grD` | Go to declaration |
| `gri` | Go to implementation |
| `grt` | Go to type definition |
| `grr` | References |
| `gO` / `gW` | Document / workspace symbols |
| `<leader>th` | Toggle inlay hints (when supported) |

### Completion (`blink.cmp`)

| Key | Action |
|---|---|
| `<Tab>` / `<S-Tab>` | Select next / previous item |
| `<CR>` | Accept |

Remaining bindings follow blink's `default` preset.

### Git (Gitsigns)

A hunk is a contiguous block of changed lines relative to the git index. Gutter signs: `+` added, `~` changed, `_` deleted, `‾` deleted at top of file.

| Key | Mode | Action |
|---|---|---|
| `]c` / `[c` | Normal | Next / previous hunk |
| `<leader>gp` | Normal | Preview hunk (floating diff) |
| `<leader>gi` | Normal | Preview hunk inline |
| `<leader>gs` | Normal / Visual | Stage or unstage hunk (Visual: selected lines only) |
| `<leader>gr` | Normal / Visual | Reset hunk (Visual: selected lines only) |
| `<leader>gS` | Normal | Stage buffer |
| `<leader>gR` | Normal | Reset buffer |
| `<leader>gb` | Normal | Blame line (full) |
| `<leader>gd` | Normal | Diff against index |
| `<leader>gD` | Normal | Diff against last commit |
| `<leader>gq` | Normal | Hunks in this file to quickfix |
| `<leader>gQ` | Normal | Hunks in the whole repo to quickfix |
| `<leader>tb` | Normal | Toggle inline blame |
| `<leader>tw` | Normal | Toggle word diff |
| `ih` | Operator / Visual | Select hunk (e.g. `dih` deletes it, `vih` selects it) |

> The hunk keys live under `<leader>g`, not Kickstart's default `<leader>h`, because `<leader>h` is window navigation.

### Neo-tree

| Key | Action |
|---|---|
| `<leader>e` | Toggle Neo-tree and reveal the current file (closes it when focused) |
| `Enter` | Open file / expand or collapse directory |
| `a` | Add file or directory (`/` suffix creates a directory) |
| `r` | Rename |
| `d` | Delete |
| `m` | Move |
| `c` | Copy |
| `H` | Toggle hidden files |
| `.` | Set directory as root |
| `Backspace` | Go to parent directory |
| `R` | Refresh tree |
| `?` | Show all mappings |

### Harpoon

Quick-access file list for jumping between actively edited files without a fuzzy finder.

| Key | Action |
|---|---|
| `<leader>a` | Add current file to the Harpoon list |
| `<leader>r` | Toggle Harpoon quick menu |
| `<leader>1` – `<leader>4` | Jump to file 1 – 4 |

### Which-key groups

| Prefix | Group |
|---|---|
| `<leader>s` | Search |
| `<leader>t` | Toggle |
| `<leader>g` | Git (Normal / Visual) |
| `gr` | LSP actions |

<details>
<summary><b>Vim basics cheat sheet</b></summary>

**Modes**

| Key | Action |
|---|---|
| `i` | Insert mode (remapped here, see above) |
| `v` / `V` | Character / line Visual mode |

**Movement**

| Key | Action |
|---|---|
| `h` `j` `k` `l` | Left / Down / Up / Right |
| `w` / `b` | Next / previous word |
| `0` / `$` | Start / end of line |
| `gg` / `G` | First / last line |
| `{` / `}` | Previous / next paragraph |

**Editing**

| Key | Action |
|---|---|
| `yy` / `dd` | Yank / delete line |
| `yap` / `dap` | Yank / delete around paragraph |
| `[count]yk` / `[count]dk` | Yank / delete `count` lines above |
| `p` / `P` | Paste below / above |
| `u` | Undo |

</details>

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

## License

See [LICENSE.md](LICENSE.md).
