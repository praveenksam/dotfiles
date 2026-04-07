#!/bin/bash
CONFIG_DIR="${CONFIG_DIR:-/Users/praveensam/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

CPU=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | cut -d'%' -f1)

sketchybar --set cpu \
  icon= \
  icon.color=$MAGENTA \
  label="${CPU}%"
