#!/usr/bin/env bash
# Plugin scripts are spawned fresh by the sketchybar daemon, not as children
# of sketchybarrc, so exported vars from colors.sh must be re-sourced here.
source "$HOME/.config/sketchybar/colors.sh"

# Invoked for each space.<id> item on aerospace_workspace_change.
# $1            = the workspace id this specific item represents
# $NAME         = this item's sketchybar name (injected by sketchybar)
# $FOCUSED_WORKSPACE = payload set by aerospace's exec-on-workspace-change

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --animate tanh 20 --set "$NAME" \
    background.color=$ACCENT_COLOR \
    background.drawing=on \
    icon.color=$BLACK
else
  sketchybar --animate tanh 20 --set "$NAME" \
    background.color=$ITEM_BG_COLOR \
    background.drawing=on \
    icon.color=$LABEL_COLOR
fi
