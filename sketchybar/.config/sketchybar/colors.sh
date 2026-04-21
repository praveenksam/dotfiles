#!/bin/bash

# Rosé Pine Dawn — Sketchybar colour palette
# Format: 0xAARRGGBB

# Base palette
export BASE=0xfffaf4ed       # background
export SURFACE=0xfff2e9e1    # raised elements
export OVERLAY=0xfffffaf3    # popups / overlays
export MUTED=0xff9893a5      # subtle text
export SUBTLE=0xffcecacd     # borders / inactive
export TEXT=0xff575279       # foreground

# Accent colours
export LOVE=0xffb4637a       # red / errors
export GOLD=0xffea9d34       # yellow / warnings
export ROSE=0xffd7827a       # orange / numbers
export PINE=0xff286983       # teal (dark)
export FOAM=0xff56949f       # cyan / strings
export IRIS=0xff907aa9       # purple / keywords

# Semantic aliases — drop-in replacements for your existing vars
export BLACK=0xff575279      # → text
export WHITE=0xfffaf4ed      # → base
export RED=0xffb4637a        # → love
export GREEN=0xff56949f      # → foam
export BLUE=0xff286983       # → pine
export YELLOW=0xffea9d34     # → gold
export ORANGE=0xffd7827a     # → rose
export MAGENTA=0xff907aa9    # → iris
export TEAL=0xff56949f       # → foam
export CYAN=0xff56949f       # → foam

# Surfaces
export SURFACE0=0xfff2e9e1   # → surface
export SURFACE1=0xfffffaf3   # → overlay
export TRANSPARENT=0x00000000

# Bar
export BAR_COLOR=0xd0faf4ed  # base at ~82% opacity — soft parchment bar
export BAR_BORDER=0xffcecacd # subtle border
