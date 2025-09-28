# SSH shortcuts
alias sshp='ssh -p 2222' # Example for custom port servers

# Multiplexed SSH sessions
alias mosh='mosh --ssh="ssh -i ~/.ssh/id_rsa"'

# Quickly tail logs remotely
rlog() { ssh "$1" "tail -f /var/log/syslog"; }

# SCP shortcut
scpup() { scp "$1" "$2:$3"; }
