#!/usr/bin/env bash
sketchybar --add item clock right \
  --set clock \
  update_freq=10 \
  icon="$ICON_CLOCK" \
  icon.color=$LABEL_COLOR \
  script="$PLUGIN_DIR/clock.sh" \
  --subscribe clock system_woke
