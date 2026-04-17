#!/bin/bash
CONFIG_DIR="${CONFIG_DIR:-/Users/praveensam/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

USED=$(vm_stat | awk '
  /Pages active/                 { active = $3 }
  /Pages wired/                  { wired = $4 }
  /Pages occupied by compressor/ { compressed = $5 }
  END { printf "%.1f", (active + wired + compressed) * 16384 / 1024 / 1024 / 1024 }
')

sketchybar --set memory \
  icon= \
  icon.color=$RED \
  label="${USED}GB"
