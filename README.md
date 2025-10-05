
cd ~/dotfiles

# Symlink everything
stow bash
stow zsh
stow config

~/.bashrc              -> ~/dotfiles/bash/.bashrc
~/.bash_profile        -> ~/dotfiles/bash/.bash_profile
~/.zshrc               -> ~/dotfiles/zsh/.zshrc
~/.config/nvim         -> ~/dotfiles/config/.config/nvim
~/.config/kitty        -> ~/dotfiles/config/.config/kitty
~/.config/starship.toml -> ~/dotfiles/config/.config/starship.toml


