#!/bin/bash

DIR_NAME=$(dirname "$0")
source "$DIR_NAME/00-base.sh"
# ========================================
servs=("git-auto-fetch")

# read the wanted apps
selection=$(
    gum choose --no-limit "${servs[@]}"
)

IFS=$'\n' read -rd '' -a array <<<"$selection"

if array_contains "${array[@]}" "git-auto-fetch"; then
    print_h3 "git-auto-fetch"

    if gum confirm --default=true --affirmative="Enable" --negative="Disable" "git-auto-fetch"; then
        # activate the service
        systemctl --user daemon-reload
        systemctl --user enable git-auto-fetch.timer
        systemctl --user start git-auto-fetch.timer
    else
        systemctl --user disable git-auto-fetch.timer
    fi
fi
