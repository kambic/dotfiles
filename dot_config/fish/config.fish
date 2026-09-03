### ADDING TO THE PATH
# First line removes the path; second line sets it.  Without the first line,
# your path gets massive and fish becomes very slow.
# set -e fish_user_paths
# set -U fish_user_paths $HOME/bin  $HOME/.local/bin /opt/rocm/bin $fish_user_paths
set -x MANPAGER "nvim +Man!"

## Set values
## Run fastfetch as welcome message
function fish_greeting
    fastfetch
end

# if status is-interactive
#     if not set -q SSH_AUTH_SOCK
#         eval (ssh-agent -c) >/dev/null
#         set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
#         set -Ux SSH_AGENT_PID $SSH_AGENT_PID
#     end
# end

# Format man pages
set -x MANPAGER "nvim +Man!"





# Get fastest mirrors
alias mirror="sudo cachyos-rate-mirrors"

# Help people new to Arch
alias tb='nc termbin.com 9999'

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

direnv hook fish | source




### ALIASES ###
# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# vim and emacs
alias vim='nvim'
alias emacs="emacsclient -c -a 'emacs'"
alias em='/usr/bin/emacsclient -nw'
alias rem="killall emacs || echo 'Emacs server not running'; /usr/bin/emacs --daemon" # Kill Emacs and restart daemon..

# Changing "ls" to "eza"
alias ls='eza -al --color=always --group-directories-first' # my preferred listing
alias la='eza -a --color=always --group-directories-first'  # all files and dirs
alias ll='eza -l --color=always --group-directories-first'  # long format
alias lt='eza -aT --color=always --group-directories-first' # tree listing
alias l.='eza -a | egrep "^\."'
alias l.='eza -al --color=always --group-directories-first ../' # ls on the PARENT directory
alias l..='eza -al --color=always --group-directories-first ../../' # ls on directory 2 levels up
alias l...='eza -al --color=always --group-directories-first ../../../' # ls on directory 3 levels up

# pacman and yay
alias pacsyu='sudo pacman -Syu'                  # update only standard pkgs
alias pacsyyu='sudo pacman -Syyu'                # Refresh pkglist & update standard pkgs
alias parsua='paru -Sua --noconfirm'             # update only AUR pkgs (paru)
alias parsyu='paru -Syu --noconfirm'             # update standard pkgs and AUR pkgs (paru)
alias unlock='sudo rm /var/lib/pacman/db.lck'    # remove pacman lock
alias orphan='sudo pacman -Rns (pacman -Qtdq)'  # remove orphaned packages (DANGEROUS!)

# content creation
alias mp3='cd Videos/dtoptions/market-outlook/ && yt-dlp -x --audio-format mp3'


# adding flags
alias df='df -h'               # human-readable sizes
alias free='free -m'           # show sizes in MB
alias grep='grep --color=auto' # colorize output (good for log files)

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

### RANDOM COLOR SCRIPT ###
# Get this script from my GitLab: gitlab.com/dwt1/shell-color-scripts
# Or install it from the Arch User Repository: shell-color-scripts
# The 'if' statement prevents colorscript from showing in 'fzf' previews.
if status is-interactive
    colorscript random
end

### SETTING THE STARSHIP PROMPT ###
starship init fish | source

### FZF ###
# Enables the following keybindings:
# CTRL-t = fzf select
# CTRL-r = fzf history
# ALT-c  = fzf cd
fzf --fish | source

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/kamba/.lmstudio/bin
# End of LM Studio CLI section
