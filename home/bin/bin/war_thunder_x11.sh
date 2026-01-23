#!/usr/bin/env bash

# -------- CONFIG ---------
WARTHUNDER_EXEC="/srv/steam_games/SteamLibrary/steamapps/common/War Thunder/launcher/aces"

# Environment
export RADV_PERFTEST="aco,nggc"
export MESA_SHADER_CACHE_DIR="$HOME/.cache/mesa_shader_cache"
export MESA_SHADER_CACHE_MAX_SIZE="10G"
export SDL_VIDEODRIVER=x11

# Run
echo "Launching War Thunder under XWayland..."
exec "$WARTHUNDER_EXEC"
