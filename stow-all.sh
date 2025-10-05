#!/bin/bash
set -e

cd "$(dirname "$0")" # cd into dotfiles dir

for pkg in bash zsh config; do
  echo "🔗 Stowing $pkg..."
  stow "$pkg"
done

echo "✅ Done!"
