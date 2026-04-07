#!/bin/bash
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

FOCUSED=$FOCUSED_WORKSPACE

for sid in 1 2 3 4 5 6 B P S; do
  # Get apps in this workspace
  apps=$(aerospace list-windows --workspace "$sid" 2>/dev/null | awk -F '|' '{gsub(/^ +| +$/, "", $2); print $2}')

  # Build icon string
  icons=""
  while IFS= read -r app; do
    [ -z "$app" ] && continue
    icons+="$(workspace_icons "$app")"
  done <<<"$apps"

  if [ "$FOCUSED" = "$sid" ]; then
    sketchybar --set space.$sid \
      background.color=$YELLOW \
      icon.color=$BLACK \
      label="$icons" \
      label.color=$BLACK \
      label.drawing=on
  else
    if [ -z "$icons" ]; then
      # Hide empty workspaces
      sketchybar --set space.$sid \
        background.color=$SURFACE0 \
        icon.color=$OVERLAY \
        label.drawing=off
    else
      sketchybar --set space.$sid \
        background.color=$SURFACE0 \
        icon.color=$WHITE \
        label="$icons" \
        label.color=$WHITE \
        label.drawing=on
    fi
  fi
done
