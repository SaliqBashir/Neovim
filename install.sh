#!/usr/bin/env bash
# One-shot bootstrap for github.com/SaliqBashir/Neovim
#
#   curl -fsSL https://raw.githubusercontent.com/SaliqBashir/Neovim/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/SaliqBashir/Neovim/main/install.sh | bash -s -- --font
#
# Flags:
#   --font          also install JetBrainsMono Nerd Font
#   --no-config     install prerequisites only; do not touch the config
#   -v, --verbose   show full command output instead of one line per step
#   -h, --help      show this help
#
# Supports: Debian/Ubuntu (apt), Arch (pacman), Fedora (dnf), macOS (brew).
# Each step prints one status line; a failing step prints the tail of its output.

set -euo pipefail

REPO_URL="https://github.com/SaliqBashir/Neovim"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
MIN_NVIM="0.11"
NVIM_PREFIX="/opt"

INSTALL_FONT=0
INSTALL_CONFIG=1
VERBOSE=0
SOFT=0

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT
LOG="$WORKDIR/step.log"

if [ -t 1 ]; then
  BLUE=$'\033[1;34m'; GREEN=$'\033[1;32m'; YELLOW=$'\033[1;33m'; RED=$'\033[1;31m'; RST=$'\033[0m'
else
  BLUE=""; GREEN=""; YELLOW=""; RED=""; RST=""
fi

# --------------------------------------------------------------------------
# output helpers
# --------------------------------------------------------------------------
log()  { printf '%s==>%s %s\n' "$BLUE" "$RST" "$*"; }
warn() { printf '%swarn:%s %s\n' "$YELLOW" "$RST" "$*" >&2; }
die()  { printf '%serror:%s %s\n' "$RED" "$RST" "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

# run <label> <command...>
# Runs the command with its output captured. Prints "==> label   ok" on success;
# on failure prints the tail of the output and returns non-zero.
# The command runs in a subshell with errexit, so a failure anywhere inside a
# function aborts that step instead of being silently ignored.
run() {
  local label="$1" rc=0
  shift
  if [ "$VERBOSE" -eq 1 ]; then
    log "$label"
    set +e; ( set -e; "$@" ); rc=$?; set -e
  else
    printf '%s==>%s %-24s ' "$BLUE" "$RST" "$label"
    set +e; ( set -e; "$@" ) >"$LOG" 2>&1; rc=$?; set -e
  fi
  hash -r
  if [ "$rc" -eq 0 ]; then
    [ "$VERBOSE" -eq 1 ] || printf '%sok%s\n' "$GREEN" "$RST"
    return 0
  fi
  if [ "$SOFT" -eq 1 ]; then
    [ "$VERBOSE" -eq 1 ] || { printf '%sskipped%s\n' "$YELLOW" "$RST"; tail -n 3 "$LOG" | sed 's/^/      /' >&2; }
    return 0
  fi
  if [ "$VERBOSE" -eq 1 ]; then
    printf '%sfailed%s\n' "$RED" "$RST" >&2
  else
    printf '%sfailed%s\n' "$RED" "$RST"
    tail -n 25 "$LOG" >&2
  fi
  return "$rc"
}

# Like run, but a failure is reported as "skipped" instead of aborting.
run_soft() { SOFT=1; run "$@"; SOFT=0; }

# --------------------------------------------------------------------------
# environment helpers
# --------------------------------------------------------------------------
SUDO=""
setup_sudo() {
  if [ "$(id -u)" -ne 0 ]; then
    have sudo || die "sudo is required when not running as root"
    SUDO="sudo"
    sudo -v || die "could not obtain sudo privileges"
  fi
}

# true if $1 >= $2, both "major.minor"
version_ge() {
  local a1="${1%%.*}" a2="${1#*.}" b1="${2%%.*}" b2="${2#*.}"
  [ "$a1" -gt "$b1" ] || { [ "$a1" -eq "$b1" ] && [ "$a2" -ge "$b2" ]; }
}

nvim_version() {
  have nvim || return 1
  nvim --version | head -n1 | sed -E 's/^NVIM v([0-9]+\.[0-9]+).*/\1/'
}

nvim_ok() {
  local v
  v="$(nvim_version 2>/dev/null)" || return 1
  version_ge "$v" "$MIN_NVIM"
}

detect_pm() {
  case "$(uname -s)" in
    Darwin) have brew || die "Homebrew is required on macOS: https://brew.sh"; echo brew ;;
    Linux)
      if   have apt-get; then echo apt
      elif have pacman;  then echo pacman
      elif have dnf;     then echo dnf
      else die "unsupported distro: need apt, pacman or dnf"
      fi ;;
    *) die "unsupported OS: $(uname -s)" ;;
  esac
}

arch_suffix() {
  case "$(uname -m)" in
    x86_64|amd64)  echo x86_64 ;;
    aarch64|arm64) echo arm64 ;;
    *) die "unsupported architecture: $(uname -m)" ;;
  esac
}

# Debian/Fedora name the binary fdfind; Telescope expects fd.
link_fd() {
  if have fdfind && ! have fd; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  fi
}

# --------------------------------------------------------------------------
# package steps (each runs inside `run`, so they stay silent on success)
# --------------------------------------------------------------------------
pkgs_apt() {
  $SUDO apt-get update -y -q
  # --no-upgrade: install what is missing, leave installed packages alone
  $SUDO env DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-upgrade \
    git build-essential unzip curl ca-certificates xz-utils \
    ripgrep fd-find nodejs npm \
    python3 python3-pip python3-venv wl-clipboard \
    imagemagick libmagickwand-dev luarocks
  link_fd
}

apt_gh() { $SUDO env DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-upgrade gh; }

pkgs_pacman() {
  $SUDO pacman -S --needed --noconfirm \
    neovim git github-cli gcc make unzip curl \
    ripgrep fd tree-sitter tree-sitter-cli \
    nodejs npm python python-pip wl-clipboard \
    imagemagick luarocks
}

pkgs_dnf() {
  $SUDO dnf install -y -q \
    neovim git gh gcc gcc-c++ make unzip curl xz \
    ripgrep fd-find nodejs npm \
    python3 python3-pip wl-clipboard \
    ImageMagick ImageMagick-devel luarocks
  link_fd
}

pkgs_brew() {
  # Only install what is missing; never upgrade or clean up unrelated formulae.
  export HOMEBREW_NO_ENV_HINTS=1 HOMEBREW_NO_INSTALL_CLEANUP=1 HOMEBREW_NO_INSTALL_UPGRADE=1
  local missing=() pair
  for pair in git:git gh:gh ripgrep:rg fd:fd tree-sitter-cli:tree-sitter node:node python:python3 imagemagick:magick luarocks:luarocks; do
    have "${pair#*:}" || missing+=("${pair%%:*}")
  done
  have nvim || missing+=(neovim)
  if [ "${#missing[@]}" -gt 0 ]; then
    brew install -q "${missing[@]}"
  fi
  if ! nvim_ok; then
    brew upgrade -q neovim
  fi
}

install_nvim_tarball() {
  nvim_ok && return 0
  local arch asset
  arch="$(arch_suffix)"
  asset="nvim-linux-${arch}"
  curl -fsSL -o "$WORKDIR/nvim.tar.gz" \
    "https://github.com/neovim/neovim/releases/latest/download/${asset}.tar.gz"
  $SUDO rm -rf "${NVIM_PREFIX:?}/${asset}"
  $SUDO tar -C "$NVIM_PREFIX" -xzf "$WORKDIR/nvim.tar.gz"
  $SUDO ln -sf "${NVIM_PREFIX}/${asset}/bin/nvim" /usr/local/bin/nvim
}

install_tree_sitter_cli() {
  have tree-sitter && return 0
  local arch
  case "$(arch_suffix)" in x86_64) arch=x64 ;; arm64) arch=arm64 ;; esac
  curl -fsSL -o "$WORKDIR/ts.gz" \
    "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-${arch}.gz"
  gunzip -f "$WORKDIR/ts.gz"
  $SUDO install -m 0755 "$WORKDIR/ts" /usr/local/bin/tree-sitter
}

install_font() {
  if [ "$(uname -s)" = "Darwin" ]; then
    brew install -q --cask font-jetbrains-mono-nerd-font
    return 0
  fi
  local dir="$HOME/.local/share/fonts/JetBrainsMonoNF"
  mkdir -p "$dir"
  curl -fsSL -o "$WORKDIR/font.tar.xz" \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
  tar -C "$dir" -xJf "$WORKDIR/font.tar.xz"
  if have fc-cache; then fc-cache -f "$dir" >/dev/null; fi
}

# --------------------------------------------------------------------------
# config
# --------------------------------------------------------------------------
lazy_sync() { nvim --headless "+Lazy! sync" +qa; }

clone_config() { git clone -q --depth 1 "$REPO_URL" "$CONFIG_DIR"; }

install_config() {
  have git || die "git is required"

  local is_repo=0
  if [ -d "$CONFIG_DIR/.git" ] &&
     git -C "$CONFIG_DIR" remote get-url origin 2>/dev/null | grep -qi 'SaliqBashir/Neovim'; then
    is_repo=1
  fi

  if [ "$is_repo" -eq 1 ]; then
    # Fast-forward only; an existing config is never overwritten.
    if [ "$VERBOSE" -eq 1 ]; then
      log "Config"
      git -C "$CONFIG_DIR" pull --ff-only || warn "pull failed; leaving config as is"
    else
      printf '%s==>%s %-24s ' "$BLUE" "$RST" "Config"
      local before after
      before="$(git -C "$CONFIG_DIR" rev-parse HEAD 2>/dev/null || true)"
      if git -C "$CONFIG_DIR" pull -q --ff-only >"$LOG" 2>&1; then
        after="$(git -C "$CONFIG_DIR" rev-parse HEAD 2>/dev/null || true)"
        if [ "$before" = "$after" ]; then
          printf '%sok%s (up to date)\n' "$GREEN" "$RST"
        else
          printf '%sok%s (updated)\n' "$GREEN" "$RST"
        fi
      else
        printf '%sskipped%s (existing config left as is)\n' "$YELLOW" "$RST"
        head -n 1 "$LOG" | sed 's/^/      /' >&2
      fi
    fi
  else
    if [ -e "$CONFIG_DIR" ]; then
      local backup
      backup="${CONFIG_DIR}.bak.$(date +%Y%m%d%H%M%S)"
      mv "$CONFIG_DIR" "$backup"
      warn "existing config moved to $backup"
    fi
    run "Config" clone_config
  fi

  run "Plugins" lazy_sync
}

# --------------------------------------------------------------------------
# main (invoked on the last line so a truncated download never runs partially)
# --------------------------------------------------------------------------
usage() {
  cat <<'USAGE'
Usage: install.sh [--font] [--no-config] [-v|--verbose] [-h|--help]
  --font          also install JetBrainsMono Nerd Font
  --no-config     install prerequisites only; do not touch the config
  -v, --verbose   show full command output instead of one line per step
USAGE
}

main() {
  local arg
  for arg in "$@"; do
    case "$arg" in
      --font)        INSTALL_FONT=1 ;;
      --no-config)   INSTALL_CONFIG=0 ;;
      -v|--verbose)  VERBOSE=1 ;;
      -h|--help)     usage; exit 0 ;;
      *) die "unknown flag: $arg" ;;
    esac
  done

  local pm
  pm="$(detect_pm)"
  [ "$pm" = "brew" ] || setup_sudo

  case "$pm" in
    apt)
      run      "Packages (apt)"   pkgs_apt
      run_soft "GitHub CLI"       apt_gh
      run      "Neovim"           install_nvim_tarball
      run_soft "tree-sitter CLI"  install_tree_sitter_cli
      ;;
    pacman)
      run      "Packages (pacman)" pkgs_pacman
      ;;
    dnf)
      run      "Packages (dnf)"   pkgs_dnf
      if ! nvim_ok; then run "Neovim" install_nvim_tarball; fi
      if ! have tree-sitter; then run_soft "tree-sitter CLI" install_tree_sitter_cli; fi
      ;;
    brew)
      run      "Packages (brew)"  pkgs_brew
      ;;
  esac

  nvim_ok || die "Neovim >= $MIN_NVIM not found on PATH after install (check 'which -a nvim')"

  if [ "$INSTALL_FONT" -eq 1 ]; then run "Nerd Font" install_font; fi
  if [ "$INSTALL_CONFIG" -eq 1 ]; then install_config; fi

  if [ -e "$HOME/.local/bin/fd" ]; then
    case ":$PATH:" in
      *":$HOME/.local/bin:"*) ;;
      *) warn "add \$HOME/.local/bin to PATH (needed for the fd symlink)" ;;
    esac
  fi

  printf '\n%sDone.%s Neovim %s' "$GREEN" "$RST" "$(nvim_version)"
  if [ "$INSTALL_CONFIG" -eq 1 ]; then printf ' · config: %s' "$CONFIG_DIR"; fi
  printf '\nLaunch with: nvim\n'
}

# Run main unless this file is being sourced (e.g. for tests).
if [ "${BASH_SOURCE[0]:-$0}" = "$0" ]; then
  main "$@"
fi
