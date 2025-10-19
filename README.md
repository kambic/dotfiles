
cd ~/dotfiles

# Symlink everything
stow bash
stow zsh
stow config
s-tui

~/.bashrc              -> ~/dotfiles/bash/.bashrc
~/.bash_profile        -> ~/dotfiles/bash/.bash_profile
~/.zshrc               -> ~/dotfiles/zsh/.zshrc
~/.config/nvim         -> ~/dotfiles/config/.config/nvim
~/.config/kitty        -> ~/dotfiles/config/.config/kitty
~/.config/starship.toml -> ~/dotfiles/config/.config/starship.toml


GNU **Stow** is a powerful and lightweight symlink manager for managing dotfiles (and beyond). When used well, it makes your setup clean, modular, and portable. Below are **Stow tips, tricks, and a breakdown of the `adopt` feature**, which is very useful for migrating existing configs.

---

## 🚀 Stow Tips & Tricks


```bash
stow bash zsh config local
```
### ✅ 2. **Dry Run First**

Before committing changes:

```bash
stow -nv bash
```

Flags:

* `-n`: don’t actually make changes (dry run)
* `-v`: verbose output

Good for verifying what will happen **before** it does.

---

### ✅ 3. **Unstow to Remove**

To remove the links created by `stow`:

```bash
stow -D bash
```

It safely removes symlinks **only if they match** the ones stowed before.

---

### ✅ 4. **Target Other Directories**

By default, Stow targets `$HOME`, but you can change it:

```bash
stow -t ~/.config config
```

Useful if you're only managing `.config` and want more control.

---

### ✅ 5. **Force Overwrites**

If a file already exists at the target, Stow will skip or complain.

You can **force overwrite**:

```bash
stow --override='*' --restow bash
```

This replaces existing conflicting files with symlinks.

---


