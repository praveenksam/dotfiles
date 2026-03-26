#!/bin/bash
source "$CONFIG_DIR/colors.sh"

USED=$(vm_stat | awk '
  /Pages active/ { active = $3 }
  /Pages wired/ { wired = $4 }
  END { printf "%.1f", (active + wired) * 4096 / 1024 / 1024 / 1024 }
')

sketchybar --set memory \
  icon= \
  icon.color=$RED \
  label="${USED}GB"
