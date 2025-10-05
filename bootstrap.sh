#!/usr/bin/env bash

set -euo pipefail

echo "🚀 Bootstrapping dotfiles..."

# Paths
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"

# Packages to stow or link manually
PACKAGES=(bash zsh config local)

# Check for GNU Stow
if command -v stow >/dev/null 2>&1; then
  echo "✅ Stow found. Using Makefile to stow dotfiles."
  make -C "$DOTFILES_DIR" stow
else
  echo "⚠️  Stow not found. Falling back to manual symlinking..."

  # === Manual: bash ===
  echo "Linking .bashrc and .bash_profile"
  ln -sf "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
  ln -sf "$DOTFILES_DIR/bash/.bash_profile" "$HOME/.bash_profile"

  # === Manual: zsh ===
  echo "Linking .zshrc"
  ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

  # === Manual: .config/*
  echo "Linking .config folders"
  mkdir -p "$CONFIG_DIR"
  for item in "$DOTFILES_DIR/config/.config/"*; do
    target="$CONFIG_DIR/$(basename "$item")"
    ln -sf "$item" "$target"
    echo "  ↪️  Linked $(basename "$item") → $target"
  done

  # === Manual: .local/bin
  echo "Linking bin scripts to ~/.local/bin"
  mkdir -p "$LOCAL_BIN"
  for script in "$DOTFILES_DIR/local/.local/bin/"*; do
    ln -sf "$script" "$LOCAL_BIN/"
    echo "  🛠️  Linked $(basename "$script")"
  done
fi

echo "✅ Bootstrap complete."
