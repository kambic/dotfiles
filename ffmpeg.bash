# ~/ffmpeg.sh
# ffprobe helpers with colorized output + JSON parsing + tabular summary w/ codec colors + bitrate

# ANSI Colors
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
MAGENTA="\033[0;35m"
RED="\033[0;31m"
RESET="\033[0m"

# Quick FFmpeg helpers
alias ffinfo='ffmpeg -hide_banner -i'

# Extract audio quickly
ffa() { ffmpeg -i "$1" -vn -acodec copy "${1%.*}.m4a"; }

# Quick transcode to h264 + aac mp4
ffh264() { ffmpeg -i "$1" -c:v libx264 -crf 23 -preset fast -c:a aac "${1%.*}_h264.mp4"; }

# Compress video for web
ffweb() { ffmpeg -i "$1" -vf "scale=1280:-2" -c:v libx264 -crf 28 -preset fast -c:a aac "${1%.*}_web.mp4"; }
# --- FUNCTIONS ---

# Colorized ffprobe - highlights video/audio streams
ffprobe-color() {
  local file="$1"
  if [[ -z "$file" ]]; then
    echo -e "${RED}Usage:${RESET} ffprobe-color <file>"
    return 1
  fi
  ffprobe -hide_banner "$file" |
    sed -E \
      -e "s/(Stream.*Video.*)/${GREEN}\1${RESET}/" \
      -e "s/(Stream.*Audio.*)/${BLUE}\1${RESET}/" \
      -e "s/(Duration:.*)/${YELLOW}\1${RESET}/"
}

# Show duration in seconds (script-friendly)
ffprobe-duration() {
  local file="$1"
  if [[ -z "$file" ]]; then
    echo -e "${RED}Usage:${RESET} ffprobe-duration <file>"
    return 1
  fi
  ffprobe -v error -show_entries format=duration \
    -of default=noprint_wrappers=1:nokey=1 "$file"
}

# Show frame rate of first video stream
ffprobe-fps() {
  local file="$1"
  if [[ -z "$file" ]]; then
    echo -e "${RED}Usage:${RESET} ffprobe-fps <file>"
    return 1
  fi
  ffprobe -v error -select_streams v:0 \
    -show_entries stream=r_frame_rate \
    -of default=noprint_wrappers=1:nokey=1 "$file"
}

# Show codec + resolution for quick inspection
ffprobe-quick() {
  local file="$1"
  if [[ -z "$file" ]]; then
    echo -e "${RED}Usage:${RESET} ffprobe-quick <file>"
    return 1
  fi
  echo -e "${YELLOW}$file${RESET}"
  ffprobe -v error -select_streams v:0 \
    -show_entries stream=codec_name,width,height,r_frame_rate \
    -of csv=p=0 "$file"
}

# Batch scan multiple files for codec/resolution info
ffprobe-batch() {
  for f in "$@"; do
    ffprobe-quick "$f"
  done
}

# Pretty-print full ffprobe JSON (with jq if available)
ffprobe-json() {
  local file="$1"
  if [[ -z "$file" ]]; then
    echo -e "${RED}Usage:${RESET} ffprobe-json <file>"
    return 1
  fi

  if command -v jq >/dev/null 2>&1; then
    ffprobe -v quiet -print_format json -show_format -show_streams "$file" | jq .
  else
    echo -e "${YELLOW}[WARN] jq not found, printing raw JSON${RESET}"
    ffprobe -v quiet -print_format json -show_format -show_streams "$file"
  fi
}

# Helper: choose codec color
_color_codec() {
  local codec="$1"
  case "$codec" in
  h264) echo -e "${GREEN}${codec}${RESET}" ;;
  hevc | h265) echo -e "${BLUE}${codec}${RESET}" ;;
  vp9) echo -e "${YELLOW}${codec}${RESET}" ;;
  av1) echo -e "${CYAN}${codec}${RESET}" ;;
  mpeg4 | mpeg2video) echo -e "${MAGENTA}${codec}${RESET}" ;;
  *) echo "$codec" ;;
  esac
}

# Tabular wrapper - quick summary with codec colors + bitrate
ffprobe-table() {
  if [[ $# -eq 0 ]]; then
    echo -e "${RED}Usage:${RESET} ffprobe-table <file1> [file2 ...]"
    return 1
  fi

  if ! command -v jq >/dev/null 2>&1; then
    echo -e "${RED}[ERROR] jq is required for ffprobe-table${RESET}"
    return 1
  fi

  printf "%-30s %-10s %-12s %-12s %-10s %-10s\n" "FILE" "CODEC" "RESOLUTION" "FPS" "DURATION" "BITRATE"
  printf "%-30s %-10s %-12s %-12s %-10s %-10s\n" "------------------------------" "--------" "------------" "------------" "--------" "--------"

  for file in "$@"; do
    local json=$(ffprobe -v quiet -print_format json -show_streams -show_format "$file")
    local codec=$(echo "$json" | jq -r '.streams[] | select(.codec_type=="video") | .codec_name' | head -n 1)
    local width=$(echo "$json" | jq -r '.streams[] | select(.codec_type=="video") | .width' | head -n 1)
    local height=$(echo "$json" | jq -r '.streams[] | select(.codec_type=="video") | .height' | head -n 1)
    local fps=$(echo "$json" | jq -r '.streams[] | select(.codec_type=="video") | .r_frame_rate' | head -n 1)
    local duration=$(echo "$json" | jq -r '.format.duration' | awk '{printf "%.2f", $1}')
    local bitrate=$(echo "$json" | jq -r '.format.bit_rate' | awk '{if ($1 > 0) printf "%.0f", $1/1000; else printf "N/A"}')
    local codec_col=$(_color_codec "$codec")
    printf "%-30s %-10b %-12s %-12s %-10s %-10s\n" "$file" "$codec_col" "${width}x${height}" "$fps" "$duration" "${bitrate}k"
  done
}
