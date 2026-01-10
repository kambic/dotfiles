# ansible-arch-linux

[![Lint](https://github.com/loganmarchione/ansible-arch-linux/actions/workflows/lint.yml/badge.svg)](https://github.com/loganmarchione/ansible-arch-linux/actions/workflows/lint.yml)

Ansible playbook to setup my Arch Linux machines (i.e., meant to be run against localhost)

## Requirements

1. Install the necessary packages
   ```
   sudo pacman -S git python
   ```
1. Clone this repo
   ```
   git clone https://github.com/loganmarchione/ansible-arch-linux.git
   cd ansible-arch-linux
   ```
1. Install Ansible
   ```
   python3 -m venv venv
   source venv/bin/activate
   pip3 install -r requirements.txt
   ```
1. Install the Ansible requirements
   ```
   ansible-galaxy install -r requirements.yml
   ```
1. (Optional) Edit the variables in `group_vars`
1. (Optional) Run the playbook in check mode to view potential changes
   ```
   ansible-playbook main.yml --ask-become-pass --check
   ````
1. Run the playbook (enter your user's password when prompted)
   ```
   ansible-playbook main.yml --ask-become-pass
   ```