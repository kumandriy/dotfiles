#!/usr/bin/env bash
sketchybar --add item cpu right \
  --set cpu \
  update_freq=5 \
  icon="$ICON_CPU" \
  icon.color=$LABEL_COLOR \
  script="$PLUGIN_DIR/cpu.sh"
