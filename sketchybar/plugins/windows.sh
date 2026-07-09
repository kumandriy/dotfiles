#!/usr/bin/env bash
source "$HOME/.config/sketchybar/colors.sh"

# Rebuilds the "windows" item label from AeroSpace's live window list for the
# currently focused workspace. Triggered by aerospace_workspace_change
# (workspace switched) and aerospace_windows_change (window created,
# destroyed, moved, or focus changed within/into a workspace).

AEROSPACE="/opt/homebrew/bin/aerospace"

WORKSPACE="${FOCUSED_WORKSPACE:-$($AEROSPACE list-workspaces --focused 2>/dev/null)}"
[ -z "$WORKSPACE" ] && exit 0

FOCUSED_APP="$($AEROSPACE list-windows --focused --format '%{app-name}' 2>/dev/null)"
APPS="$($AEROSPACE list-windows --workspace "$WORKSPACE" --format '%{app-name}' 2>/dev/null | sort -u)"

if [ -z "$APPS" ]; then
  sketchybar --set "$NAME" label="(empty)" label.color=$DIM_COLOR
  exit 0
fi

LABEL=""
while IFS= read -r app; do
  [ -z "$app" ] && continue
  if [ "$app" = "$FOCUSED_APP" ]; then
    ENTRY="● $app"
  else
    ENTRY="$app"
  fi
  if [ -z "$LABEL" ]; then
    LABEL="$ENTRY"
  else
    LABEL="$LABEL   $ENTRY"
  fi
done <<< "$APPS"

sketchybar --set "$NAME" label="$LABEL" label.color=$LABEL_COLOR
