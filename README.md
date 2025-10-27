# Symlink everything

https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html

stow bash
stow zsh
stow config
s-tui
termscp
https://terminaltrove.com/explore/

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

- `-n`: don’t actually make changes (dry run)
- `-v`: verbose output

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
