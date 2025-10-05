
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


GNU **Stow** is a powerful and lightweight symlink manager for managing dotfiles (and beyond). When used well, it makes your setup clean, modular, and portable. Below are **Stow tips, tricks, and a breakdown of the `adopt` feature**, which is very useful for migrating existing configs.

---

## 🧠 **What Is Stow, Exactly?**

Stow works by creating **symbolic links** from a central directory (your dotfiles repo) to target locations like `$HOME` or `~/.config`.

If you have this:

```
~/dotfiles/bash/.bashrc
```

Then:

```bash
stow bash
```

Creates:

```
~/.bashrc → ~/dotfiles/bash/.bashrc
```

It **recursively links files and directories**, mirroring the structure inside each "package" folder.

---

## 🚀 Stow Tips & Tricks

### ✅ 1. **Keep Modular Structure**

Split config logically:

```
~/dotfiles/
├── bash/
│   └── .bashrc
├── zsh/
│   └── .zshrc
├── config/
│   └── .config/
│       ├── nvim/
│       └── kitty/
├── local/
│   └── .local/
│       └── bin/
```

Then just run:

```bash
stow bash zsh config local
```

Each will symlink only its own files — keeping everything clean and reversible.

---

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

## 📦 `stow --adopt`: Magic for Migration

### 🧩 What is `--adopt`?

```bash
stow --adopt bash
```

This is used to **move existing dotfiles into your Stow repo** while preserving them via symlinks.

#### 🔁 Example:

You already have:

```
~/.bashrc
```

Run:

```bash
mkdir -p ~/dotfiles/bash
cd ~/dotfiles
stow --adopt bash
```

This will:

1. **Move** `~/.bashrc` into `~/dotfiles/bash/.bashrc`
2. Create a symlink from `~/.bashrc → ~/dotfiles/bash/.bashrc`

> 🧠 It “adopts” unmanaged files into your dotfiles repo without breaking your setup.

### 🔒 Tip:

Use `--adopt` with `--simulate` first:

```bash
stow --adopt --simulate bash
```

To see what files would be moved and linked.

---

## 🛠 Best Practices

| Tip                                                                 | Why                                                        |
| ------------------------------------------------------------------- | ---------------------------------------------------------- |
| Keep dotfiles in a Git repo                                         | Version control your config, share, and back up            |
| Use one directory per package                                       | Makes linking, removing, and stowing specific configs easy |
| Don't stow over non-symlinked files blindly                         | You risk overwriting local changes                         |
| Use `.config/`, `.local/`, `.bashrc` structure inside Stow packages | Avoids conflicts and clutter                               |

---

## 🔁 Use Case Summary

| Action                     | Command                        |
| -------------------------- | ------------------------------ |
| Stow a package             | `stow bash`                    |
| Remove a stow package      | `stow -D bash`                 |
| See what will happen       | `stow -nv bash`                |
| Target a specific location | `stow -t ~/.config config`     |
| Force update symlinks      | `stow --restow bash`           |
| Adopt existing files       | `stow --adopt bash`            |
| Simulate adoption          | `stow --adopt --simulate bash` |

---

Let me know if you’d like a **starter dotfiles repo layout** with `stow`-ready structure or a Makefile to automate common actions.
