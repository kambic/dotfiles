### EXPORT ###
set fish_greeting                                 # Supresses fish's intro message


# if status is-interactive
# 		set POSH agnoster
# 		oh-my-posh init -c ~/.config/ohmyposh/zen.toml fish | source
# # -----------------------------------------------------
# end


### RANDOM COLOR SCRIPT ###
if status is-interactive
    colorscript exec suckless
end

### SETTING THE STARSHIP PROMPT ###
starship init fish | source

for file in ~/.config/fish/conf.d/*.fish
    source $file
end

### FZF ###
# Enables the following keybindings:
# CTRL-t = fzf select
# CTRL-r = fzf history
# ALT-c  = fzf cd
fzf --fish | source
umask 002
