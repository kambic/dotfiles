#!/usr/bin/env bash
set -e

echo "=== Resetting GTK & Qt user configs ==="

# GTK 2.x
if [ -f "$HOME/.gtkrc-2.0" ]; then
  echo "Removing GTK2 config..."
  rm -f "$HOME/.gtkrc-2.0"
fi

# GTK 3 & 4
for dir in "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"; do
  if [ -d "$dir" ]; then
    echo "Removing $dir..."
    rm -rf "$dir"
  fi
done

# Qt (KDE) configs
for file in "$HOME/.config/kdeglobals" "$HOME/.config/qt5ct" "$HOME/.config/qt6ct"; do
  if [ -e "$file" ]; then
    echo "Removing $file..."
    rm -rf "$file"
  fi
done

# Icon & cursor theme caches
if [ -d "$HOME/.icons" ]; then
  echo "Removing custom icons..."
  rm -rf "$HOME/.icons"
fi
if [ -d "$HOME/.local/share/icons" ]; then
  echo "Removing locally installed icon themes..."
  rm -rf "$HOME/.local/share/icons"
fi

# GTK icon cache rebuild
echo "Rebuilding GTK icon cache..."
if command -v gtk-update-icon-cache &>/dev/null; then
  gtk-update-icon-cache -f /usr/share/icons/hicolor || true
fi

echo "Done. Log out and log back in to apply defaults."

# rm -rf ~/.cache/*
# kbuildsycoca5
