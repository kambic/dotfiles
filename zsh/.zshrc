##### --- CORE ZSH SETUP --- #####

# History
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt share_history hist_ignore_all_dups

# Options for sane defaults
setopt autocd correct
setopt extended_glob
setopt nocaseglob

# Completion & colors
autoload -U compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
export LS_COLORS="di=1;34:ln=36:so=35:pi=33:ex=1;32:bd=1;33:cd=1;33:su=1;41:sg=1;46:tw=1;44:ow=1;34"

# Oh-my-zsh installation path
ZSH=~/.oh-my-zsh
# List of plugins used
plugins=(
	docker
	docker-compose
	fabric qrcode
	uv
	sudo
	supervisor
	starship
	zsh-autosuggestions
	zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

function vv() {
	# Assumes all configs exist in directories named ~/.config/nvim-*
	local config=$(fd --max-depth 1 --glob 'nvim-*' ~/.config | fzf --prompt="Neovim Configs > " --height=~50% --layout=reverse --border --exit-0)

	# If I exit fzf without selecting a config, don't open Neovim
	[[ -z $config ]] && echo "No config selected" && return

	# Open Neovim with the selected config
	NVIM_APPNAME=$(basename $config) nvim $@
}

function fzf-pi() {
	pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S

}
function fzf-pr() {
	pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns
}

  
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd <"$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Helpful aliases
alias c='clear'                                                                    # clear terminal
alias l='eza -lh --icons=auto --hyperlink'                                         # long list
alias ls='eza -1 --icons=auto --hyperlink'                                         # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first --hyperlink' # long list all
alias ld='eza -lhD --icons=auto --hyperlink'                                       # long list dirs
alias lt='eza --icons=auto --tree --hyperlink'                                     # list folder as tree
alias pql='yay -Ql'
alias pqo='yay -Qo'

# Directory navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'
alias ip='ip -c'
alias lsusb=cyme

alias s='kitten ssh'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias cze='chezmoi edit'
alias cza='chezmoi add'
alias czc='chezmoi cd'
alias sf='sudo fish'

source <(fzf --zsh)
