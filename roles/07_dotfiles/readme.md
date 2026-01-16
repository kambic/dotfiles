Here's a clean Ansible role structure that deploys **user dotfiles** and `~/.config/*` files using **file links** (not copying folders recursively).

### Role name suggestion: `user.dotfiles`

```
roles/
└── user.dotfiles/
    ├── defaults/
    │   └── main.yml
    ├── tasks/
    │   └── main.yml
    └── files/
        ├── dotfiles/
        │   ├── .bashrc
        │   ├── .bash_profile
        │   ├── .inputrc
        │   ├── .zshrc
        │   ├── .zprofile
        │   ├── .zshenv
        │   ├── .config/
        │   │   ├── starship.toml
        │   │   ├── fish/
        │   │   │   └── config.fish
        │   │   ├── git/
        │   │   │   └── config
        │   │   ├── helix/
        │   │   │   └── config.toml
        │   │   └── ...
        └── ...
```

### defaults/main.yml

```yaml
---
# user.dotfiles/defaults/main.yml

dotfiles_user: "{{ ansible_user_id }}"           # usually correct, override when needed

dotfiles_home: "{{ lookup('env','HOME') | default('/home/' + dotfiles_user, true) }}"

# Where are your dotfiles located on the control node (relative to role/files/)
dotfiles_src_root: "dotfiles"

# Which shells should get their rc files linked
dotfiles_shells:
  - bash
  - zsh
  - fish

# Map shell → list of files to link (relative to dotfiles_src_root)
dotfiles_shell_files:
  bash:
    - .bashrc
    - .bash_profile
    - .bash_logout
    - .inputrc
  zsh:
    - .zshrc
    - .zprofile
    - .zshenv
  fish:
    - .config/fish/config.fish
    - .config/fish/conf.d/prompt.fish   # example

# Files / folders directly under ~/.config to symlink
dotfiles_config_entries:
  - starship.toml
  - fish
  - git
  - helix
  - nvim
  - wezterm
  - bat
  - bottom
  - fd
  - ripgrep

# Whether to remove existing regular files/directories before linking
dotfiles_force_overwrite: true

# Create ~/.config if missing
dotfiles_ensure_config_dir: true
```

### tasks/main.yml

```yaml
---
# roles/user.dotfiles/tasks/main.yml

- name: Ensure user home exists
  ansible.builtin.file:
    path: "{{ dotfiles_home }}"
    state: directory
    owner: "{{ dotfiles_user }}"
    group: "{{ dotfiles_user }}"
    mode: '0755'

- name: Ensure ~/.config exists
  when: dotfiles_ensure_config_dir | bool
  ansible.builtin.file:
    path: "{{ dotfiles_home }}/.config"
    state: directory
    owner: "{{ dotfiles_user }}"
    group: "{{ dotfiles_user }}"
    mode: '0755'

# ────────────────────────────────────────────────
#   Shell rc files (in home)
# ────────────────────────────────────────────────

- name: Link shell configuration files
  ansible.builtin.file:
    src:    "{{ role_path }}/files/{{ dotfiles_src_root }}/{{ item.1 }}"
    dest:   "{{ dotfiles_home }}/{{ item.1 | basename }}"
    state:  link
    force:  "{{ dotfiles_force_overwrite | bool }}"
    owner:  "{{ dotfiles_user }}"
    group:  "{{ dotfiles_user }}"
  loop: "{{ dotfiles_shells | subelements(dotfiles_shell_files, skip_missing=True) }}"
  loop_control:
    label: "{{ item.1 }}  →  ~/.{{ item.1 | basename }}"

# ────────────────────────────────────────────────
#   ~/.config entries (link files **and** folders)
# ────────────────────────────────────────────────

- name: Link .config entries (files + whole folders)
  ansible.builtin.file:
    src:    "{{ role_path }}/files/{{ dotfiles_src_root }}/.config/{{ item }}"
    dest:   "{{ dotfiles_home }}/.config/{{ item }}"
    state:  link
    force:  "{{ dotfiles_force_overwrite | bool }}"
    follow: false
    owner:  "{{ dotfiles_user }}"
    group:  "{{ dotfiles_user }}"
  loop: "{{ dotfiles_config_entries }}"
  loop_control:
    label: "{{ item }}  →  ~/.config/{{ item }}"

# Optional: remove broken symlinks (cleanup)
- name: Remove broken symlinks in home
  when: dotfiles_force_overwrite | bool
  ansible.builtin.find:
    paths: "{{ dotfiles_home }}"
    depth: 1
    file_type: link
    excludes: "{{ dotfiles_shell_files.values() | flatten | map('basename') | list }}"
    patterns: ".*"
  register: broken_links_find
  changed_when: false

- name: Clean broken dotfile symlinks
  ansible.builtin.file:
    path: "{{ item.path }}"
    state: absent
  loop: "{{ broken_links_find.files | default([]) }}"
  when: broken_links_find.matched > 0
```

### Usage example (playbook)

```yaml
- hosts: localhost
  become: no

  roles:
    - role: user.dotfiles
      vars:
        dotfiles_user: "your-username"
        dotfiles_force_overwrite: true
        dotfiles_config_entries:
          - starship.toml
          - fish
          - git
          - helix
          - wezterm
          - nvim
```

### Recommended alternative folder layout (cleaner)

Many people prefer this structure:

```
files/
└── home/
    ├── .bashrc
    ├── .zshrc
    ├── .config/
    │   ├── fish/
    │   ├── nvim/
    │   ├── helix/
    │   └── starship.toml
```

Then just change paths:

```yaml
src: "{{ role_path }}/files/home/{{ item.1 }}"
dest: "{{ dotfiles_home }}/{{ item.1 }}"
```

and

```yaml
src: "{{ role_path }}/files/home/.config/{{ item }}"
dest: "{{ dotfiles_home }}/.config/{{ item }}"
```

Good luck with your dotfiles! 🐟🐚🦀
