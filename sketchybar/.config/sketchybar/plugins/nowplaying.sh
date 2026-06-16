#!/bin/bash

RESULT=$(/opt/homebrew/bin/media-control get 2>/dev/null)

if [ -z "$RESULT" ] || [ "$RESULT" = "null" ]; then
  sketchybar --set $NAME drawing=off
  exit 0
fi

PLAYING=$(echo "$RESULT" | jq -r '.playing')
TITLE=$(echo "$RESULT" | jq -r '.title // ""')
ARTIST=$(echo "$RESULT" | jq -r '.artist // ""')

if [ "$PLAYING" = "true" ] && [ -n "$TITLE" ]; then
  if [ -n "$ARTIST" ]; then
    DISPLAY="$ARTIST — $TITLE"
  else
    DISPLAY="$TITLE"
  fi
  # Truncate if too long
  if [ ${#DISPLAY} -gt 40 ]; then
    DISPLAY="${DISPLAY:0:37}..."
  fi
  sketchybar --set $NAME label="$DISPLAY" drawing=on
else
  sketchybar --set $NAME drawing=off
fi
