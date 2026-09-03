# ~/.config/fish/conf.d/ssh-agent.fish
# Starts ssh-agent once and shares it across every terminal, tmux pane, and
# login. State is persisted to a file so new shells reattach instead of
# spawning duplicate agents.
#
# If your distro runs gnome-keyring or a systemd user unit for ssh-agent,
# SSH_AUTH_SOCK will already be set and this file does nothing.

status is-login; or status is-interactive; or exit

# Respect an agent that's already available (systemd unit, keyring, forwarded agent…)
if set -q SSH_AUTH_SOCK; and test -S "$SSH_AUTH_SOCK"
    exit
end

set -l ssh_env ~/.ssh/agent.fish

# Try to reattach to a previously started agent
if test -r $ssh_env
    source $ssh_env >/dev/null
end

# Validate: does the recorded agent actually respond?
#   ssh-add -l exit codes: 0 = keys listed, 1 = no keys (agent fine), 2 = no agent
function __ssh_agent_alive
    set -q SSH_AUTH_SOCK; or return 1
    ssh-add -l >/dev/null 2>&1
    test $status -ne 2
end

if not __ssh_agent_alive
    # Stale or missing — start a fresh agent and persist its env in fish syntax
    mkdir -p ~/.ssh; chmod 700 ~/.ssh
    ssh-agent -c | sed 's/^setenv/set -gx/; s/;$//' >$ssh_env
    chmod 600 $ssh_env
    source $ssh_env >/dev/null
end
functions -e __ssh_agent_alive

# Optional: auto-add your default key on first use of the day.
# Uncomment if you don't use a keyring prompt:
# ssh-add -l >/dev/null 2>&1; or ssh-add ~/.ssh/id_ed25519 2>/dev/null
