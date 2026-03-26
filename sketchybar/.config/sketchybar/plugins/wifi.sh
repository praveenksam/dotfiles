#!/bin/bash
source "$CONFIG_DIR/colors.sh"

WIFI=$(networksetup -getairportnetwork en0 | cut -d' ' -f4-)
IP=$(ipconfig getifaddr en0)

if [ -z "$IP" ]; then
  sketchybar --set wifi \
    icon=󰤭 \
    icon.color=$RED \
    label="No Network"
else
  sketchybar --set wifi \
    icon=󰤨 \
    icon.color=$TEAL \
    label="$IP"
fi
