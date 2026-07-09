#!/usr/bin/env bash
source "$HOME/.config/sketchybar/colors.sh"

# sketchybar's built-in volume_change event supplies the new level in $INFO.
# On the very first run (item just created, no event fired yet) fall back to
# querying the system directly so the label isn't blank.

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"
else
  VOLUME="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)"
fi

[ -z "$VOLUME" ] && exit 0

if [ "$VOLUME" -eq 0 ] 2>/dev/null; then
  ICON=""   # volume_off / muted
elif [ "$VOLUME" -lt 30 ]; then
  ICON=""   # volume_down
else
  ICON=""   # volume_up
fi

sketchybar --set "$NAME" icon="$ICON" icon.color=$LABEL_COLOR label="${VOLUME}%"
