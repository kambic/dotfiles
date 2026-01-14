
### ADDING TO THE PATH
# First line removes the path; second line sets it.  Without the first line,
# your path gets massive and fish becomes very slow.
set -e fish_user_paths
set -U fish_user_paths $HOME/.bin  $HOME/.local/bin /var/lib/flatpak/exports/bin/ $fish_user_paths

### EXPORT ###
set fish_greeting                                 # Supresses fish's intro message

### SET FZF DEFAULTS
set -gx FZF_DEFAULT_OPTS "--layout=reverse --exact --border=bold --border=rounded --margin=3% --color=dark"


# if status is-interactive
# 		set POSH agnoster
# 		oh-my-posh init -c ~/.config/ohmyposh/zen.toml fish | source
# # -----------------------------------------------------
# end

# Changing "ls" to "eza"
alias l='eza -lh --color=always --group-directories-first' # my preferred listing
alias ls='eza -al --color=always --group-directories-first' # my preferred listing
alias la='eza -a --color=always --group-directories-first'  # all files and dirs
alias ll='eza -l --color=always --group-directories-first'  # long format
alias lt='eza -aT --color=always --group-directories-first' # tree listing
alias l.='eza -a | egrep "^\."'
alias l.='eza -al --color=always --group-directories-first ../' # ls on the PARENT directory
alias l..='eza -al --color=always --group-directories-first ../../' # ls on directory 2 levels up



function vv
    set -l cache_file ~/.cache/vv_last_nvim

    # Ensure cache dir exists
    mkdir -p ~/.cache

    # Load last selection if it exists
    set -l last ""
    if test -f $cache_file
        set last (cat $cache_file)
    end

    # Select config
    set -l config (
        fd --max-depth 1 --glob 'nvim-*' ~/.config \
        | sort \
        | fzf \
            --prompt="Neovim Configs > " \
            --height=50% \
            --layout=reverse \
            --border \
            --exit-0
    )

    # If nothing selected, exit
    if test -z "$config"
        echo "No config selected"
        return
    end

    # Cache selection
    echo $config > $cache_file

    # Launch Neovim with selected config
    set -l appname (basename "$config")
    env NVIM_APPNAME=$appname nvim $argv
end
function su
   command su --shell=/usr/bin/fish $argv
end
function lsusb --wraps=cyme --description 'alias lsusb cyme'
    cyme $argv
end

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

### RANDOM COLOR SCRIPT ###
# Get this script from my GitLab: gitlab.com/dwt1/shell-color-scripts
# Or install it from the Arch User Repository: shell-color-scripts
# The 'if' statement prevents colorscript from showing in 'fzf' previews.
if status is-interactive
    colorscript exec suckless

end

### SETTING THE STARSHIP PROMPT ###
starship init fish | source

### FZF ###
# Enables the following keybindings:
# CTRL-t = fzf select
# CTRL-r = fzf history
# ALT-c  = fzf cd
fzf --fish | source
umask 002
