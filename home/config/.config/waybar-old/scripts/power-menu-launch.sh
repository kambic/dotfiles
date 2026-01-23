#!/bin/bash

kitty --class kitty-menu -e ~/.config/waybar/scripts/power-menu.sh &

# wait for the window to exist
sleep 0.2

# focus it
hyprctl dispatch focuswindow class:kitty-menu

# move cursor to focused window center
hyprctl dispatch movecursor focus
