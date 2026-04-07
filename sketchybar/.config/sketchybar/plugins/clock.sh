#!/bin/bash
CONFIG_DIR="${CONFIG_DIR:-/Users/praveensam/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"
sketchybar --set clock label="$(date '+%a %d %b  %H:%M')"
