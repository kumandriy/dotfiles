#!/usr/bin/env bash
# Left side: AeroSpace workspace indicator + live app membership of the
# focused workspace. Driven by two custom sketchybar events that AeroSpace
# triggers via its callbacks (see ~/.config/aerospace/aerospace.toml):
#   aerospace_workspace_change  -> focused workspace switched
#   aerospace_windows_change    -> a window was created/destroyed/moved/focused

sketchybar --add event aerospace_workspace_change
sketchybar --add event aerospace_windows_change

AEROSPACE="/opt/homebrew/bin/aerospace"

# One pill item per AeroSpace workspace, in order, so ALL workspaces are
# always visible (not just occupied ones).
for sid in $($AEROSPACE list-workspaces --all); do
  sketchybar --add item space."$sid" left \
    --subscribe space."$sid" aerospace_workspace_change \
    --set space."$sid" \
    icon="$sid" \
    icon.padding_left=10 \
    icon.padding_right=10 \
    icon.color=$LABEL_COLOR \
    label.drawing=off \
    background.color=$ITEM_BG_COLOR \
    background.corner_radius=6 \
    background.height=24 \
    background.drawing=on \
    click_script="$AEROSPACE workspace $sid" \
    script="$PLUGIN_DIR/workspace.sh $sid"
done

# Divider between the workspace switcher and the live app list
sketchybar --add item space_divider left \
  --set space_divider \
  icon="$DIVIDER" \
  icon.color=$DIM_COLOR \
  icon.padding_left=8 \
  icon.padding_right=8 \
  label.drawing=off

# Live list of app names present in the currently focused workspace
sketchybar --add item windows left \
  --subscribe windows aerospace_workspace_change aerospace_windows_change \
  --set windows \
  icon.drawing=off \
  label.color=$LABEL_COLOR \
  label.font="$FONT:Medium:12.5" \
  label.max_chars=64 \
  padding_left=4 \
  script="$PLUGIN_DIR/windows.sh"

# Prime initial state (bar just (re)started) so highlighting + app list are
# correct immediately, without waiting for the first workspace switch.
sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$($AEROSPACE list-workspaces --focused)"
