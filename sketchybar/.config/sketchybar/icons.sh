#!/bin/bash

function workspace_icons() {
  source "$CONFIG_DIR/icon_map.sh"
  __icon_map "$1"
  echo "$icon_result"
}
