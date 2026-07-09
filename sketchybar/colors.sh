#!/usr/bin/env bash
# Color palette — all variables MUST be exported: sketchybar plugin scripts
# run as separate processes spawned by the sketchybar binary, not as children
# of this sourced script, so only exported vars are visible to them.

export BLACK=0xff181926
export WHITE=0xffcad3f5
export RED=0xffed8796
export GREEN=0xffa6da95
export BLUE=0xff8aadf4
export YELLOW=0xffeed49f
export ORANGE=0xfff5a97f
export MAGENTA=0xffc6a0f6
export GREY=0xff6e738d
export TRANSPARENT=0x00000000

# Bar / item semantics
export BAR_COLOR=0xf0181926        # near-opaque dark bar background
export ITEM_BG_COLOR=0x33ffffff    # translucent pill for inactive workspace
export ACCENT_COLOR=$BLUE          # active workspace highlight
export LABEL_COLOR=$WHITE
export ICON_COLOR=$WHITE
export DIM_COLOR=$GREY
