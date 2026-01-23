#!/usr/bin/env bash
# -----------------------------
# War Thunder Linux Launcher Wrapper
# -----------------------------

# -------- CONFIGURATION ---------
# Screen resolution and refresh rate
WIDTH=2560
HEIGHT=1440
REFRESH=165

# Path to War Thunder executable
# Change this if you installed it elsewhere
# WARTHUNDER_EXEC="$HOME/.local/share/WarThunder/launcher/WarThunderLauncher.x86_64"
# WARTHUNDER_EXEC="/srv/steam_games/SteamLibrary/steamapps/common/War Thunder/launcher"
# WARTHUNDER_EXEC="/srv/steam_games/SteamLibrary/steamapps/common/War Thunder/launcher/aces"
WARTHUNDER_EXEC="/srv/steam_games/SteamLibrary/steamapps/common/WarThunder/linux64/aces"
# Enable GameMode if installed
if command -v gamemoderun &>/dev/null; then
	GAMEMODE="gamemoderun"
else
	GAMEMODE=""
fi

# -------- ENVIRONMENT ---------
export RADV_PERFTEST="aco,nggc"
export MESA_SHADER_CACHE_DIR="$HOME/.cache/mesa_shader_cache"
export MESA_SHADER_CACHE_MAX_SIZE="10G"
# export SDL_VIDEODRIVER="wayland"
export SDL_VIDEODRIVER=x11

# -------- LAUNCH ---------
echo "Launching War Thunder via Gamescope on Wayland..."
echo "Resolution: ${WIDTH}x${HEIGHT}@${REFRESH}Hz"
echo "Using War Thunder executable: $WARTHUNDER_EXEC"

$GAMEMODE gamescope \
	-W $WIDTH -H $HEIGHT \
	-r $REFRESH \
	-f \
	--adaptive-sync \
	--force-grab-cursor \
	-- \
	"$WARTHUNDER_EXEC"
