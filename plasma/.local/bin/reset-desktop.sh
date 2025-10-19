#!/usr/bin/env bash
set -e

echo "=== Full Desktop Reset (GTK + Qt + KDE Plasma) ==="
echo "This will wipe user-level configs and caches."
read -rp "Are you sure? (y/N): " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || {
  echo "Aborted."
  exit 1
}

### --- GTK RESET ---
echo "--- Resetting GTK configs ---"
rm -f "$HOME/.gtkrc-2.0"
rm -rf "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"

rm -rf "$HOME/.icons" "$HOME/.local/share/icons"
if command -v gtk-update-icon-cache &>/dev/null; then
  gtk-update-icon-cache -f /usr/share/icons/hicolor || true
fi

### --- QT/KDE RESET ---
echo "--- Resetting Qt & KDE configs ---"
rm -rf "$HOME/.config/kdeglobals"
rm -rf "$HOME/.config/qt5ct" "$HOME/.config/qt6ct"

# Plasma-specific configs
rm -rf "$HOME/.config/plasma*" \
  "$HOME/.config/kscreenlockerrc" \
  "$HOME/.config/ksplashrc" \
  "$HOME/.config/khotkeysrc" \
  "$HOME/.config/krunnerrc" \
  "$HOME/.config/kwinrc" \
  "$HOME/.config/systemsettingsrc" \
  "$HOME/.config/ksmserverrc" \
  "$HOME/.config/kdeconnect" \
  "$HOME/.config/kscreen"

# Plasma layouts & activities
rm -rf "$HOME/.local/share/plasma*" \
  "$HOME/.local/share/kxmlgui5" \
  "$HOME/.local/share/kscreen"

# Reset cache
echo "--- Clearing cache ---"
rm -rf "$HOME/.cache/*"
if command -v kbuildsycoca6 &>/dev/null; then
  kbuildsycoca6 --noincremental
elif command -v kbuildsycoca5 &>/dev/null; then
  kbuildsycoca5 --noincremental
fi

echo "=== Done. Log out or reboot to apply a fresh Plasma session. ==="
