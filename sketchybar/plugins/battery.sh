#!/usr/bin/env bash
source "$HOME/.config/sketchybar/colors.sh"

# Battery percentage + charging-state aware icon (Font Awesome / Hack Nerd Font)

BATT_INFO="$(pmset -g batt)"
PERCENTAGE="$(echo "$BATT_INFO" | grep -Eo "[0-9]+%" | head -1 | cut -d% -f1)"
CHARGING="$(echo "$BATT_INFO" | grep -E 'AC Power|charging')"

[ -z "$PERCENTAGE" ] && exit 0

case "${PERCENTAGE}" in
  9[0-9]|100) ICON="" ;;   # battery_full
  [6-8][0-9])  ICON="" ;;  # battery_three_quarters
  [3-5][0-9])  ICON="" ;;  # battery_half
  1[0-9])      ICON="" ;;  # battery_quarter
  [1-9])       ICON="" ;;  # battery_empty
  *)           ICON="" ;;
esac

COLOR=$LABEL_COLOR
if echo "$BATT_INFO" | grep -q 'AC Power'; then
  ICON=""  # bolt (charging)
  COLOR=$GREEN
elif [ "$PERCENTAGE" -le 20 ]; then
  COLOR=$RED
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
