#!/bin/bash
COUNT=$(/opt/homebrew/bin/docker ps -q 2>/dev/null | wc -l | tr -d ' ')

echo "$(date): ran, COUNT=$COUNT" >>/tmp/docker-sketchybar.log

if [ "$COUNT" -eq 0 ]; then
  sketchybar --set docker icon=󰡨 icon.color=0xff494d64 label=""
else
  sketchybar --set docker icon=󰡨 icon.color=0xff2a84d2 label="${COUNT}"
fi
