#!/bin/bash
source "$CONFIG_DIR/colors.sh"

PERCENTAGE=$(pmset -g batt | grep -o '[0-9]*%' | head -1 | tr -d '%')
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ "$CHARGING" != "" ]; then
  ICON="󰂄"
  COLOR=$GREEN
elif [ "$PERCENTAGE" -gt 80 ]; then
  ICON="󰁹"
  COLOR=$GREEN
elif [ "$PERCENTAGE" -gt 50 ]; then
  ICON="󰁾"
  COLOR=$YELLOW
elif [ "$PERCENTAGE" -gt 20 ]; then
  ICON="󰁼"
  COLOR=$ORANGE
else
  ICON="󰁺"
  COLOR=$RED
fi

sketchybar --set battery icon="$ICON" icon.color=$COLOR label="${PERCENTAGE}%"
