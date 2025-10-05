# Fish Configuration
# -----------------------------------------------------

# Remove the fish greetings
set -g fish_greeting

# Start neofetch
neofetch

# Sets starship as the promt
eval (starship init fish)

# Start atuin
# atuin init fish | source

# List Directory
alias l='eza -lh  --icons=auto --hyperlink' # long list
alias ls= 'eza -1   --icons=auto --hyperlink' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first --hyperlink' # long list all
alias ld='eza -lhD --icons=auto --hyperlink' # long list dirs
alias lt='eza --icons=auto --tree --hyperlink' # list folder as treabbr df "df -T -h"

abbr hashed_password "openssl passwd -apr1"
abbr lsblk "lsblk -f"

abbr ip 'ip -c'
abbr lsusb cyme

alias s='kitten ssh'
abbr update-grub 'sudo grub-mkconfig -o /boot/grub/grub.cfg'
abbr cze 'chezmoi edit'
abbr cza 'chezmoi add'
abbr czc 'chezmoi cd'
abbr sf 'sudo fish'

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
abbr mkdir 'mkdir -p'

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function vv
    # NVIM_APPNAME=nvim-vanila nvim $argv
    # Assumes all configs exist in directories named ~/.config/nvim-*
    set config $(fd --max-depth 1 --glob 'nvim-*' ~/.config | fzf --prompt="Neovim Configs > " --height=~50% --layout=reverse --border --exit-0)

    if not set -q config[1]
        echo "No config selected"
    else
        echo $config
        echo "selected conf"
        NVIM_APPNAME=$(basename $config) nvim $argv
    end
    # Open Neovim with the selected config
end
