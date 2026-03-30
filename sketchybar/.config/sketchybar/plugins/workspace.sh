#!/bin/bash
source "$CONFIG_DIR/colors.sh"

FOCUSED=$FOCUSED_WORKSPACE

for sid in 1 2 3 4 5 6 B P S; do
  WORKSPACE="${sid}"
  if [ "$FOCUSED" = "$WORKSPACE" ]; then
    sketchybar --set space.$sid \
      background.color=$TEAL \
      icon.color=$BLACK
  else
    sketchybar --set space.$sid \
      background.color=$SURFACE0 \
      icon.color=$WHITE
  fi
done
