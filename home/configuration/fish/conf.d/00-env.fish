### ADDING TO THE PATH
# First line removes the path; second line sets it.  Without the first line,
# your path gets massive and fish becomes very slow.
set -e fish_user_paths
set -U fish_user_paths $HOME/.bin  $HOME/.local/bin /var/lib/flatpak/exports/bin/ $fish_user_paths

# Disable greeting
set -U fish_greeting


### SET FZF DEFAULTS
set -gx FZF_DEFAULT_OPTS "--layout=reverse --exact --border=bold --border=rounded --margin=3% --color=dark"


set -U fish_user_paths /usr/lib/ccache/bin/
set -U fish_user_paths $HOME/.bin  $HOME/.local/bin /var/lib/flatpak/exports/bin/ $fish_user_paths
