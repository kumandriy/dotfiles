#!/usr/bin/env bash
source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

WIFI_IFACE="$(networksetup -listallhardwareports 2>/dev/null | awk '/Wi-Fi/{getline; print $2}')"
[ -z "$WIFI_IFACE" ] && WIFI_IFACE="en0"

IP="$(ipconfig getifaddr "$WIFI_IFACE" 2>/dev/null)"

if [ -n "$IP" ]; then
  SSID="$(ipconfig getsummary "$WIFI_IFACE" 2>/dev/null | awk -F ' SSID : ' '/ SSID : / {print $2}')"
  sketchybar --set "$NAME" icon="$ICON_WIFI_ON" icon.color=$LABEL_COLOR label="${SSID:-Connected}"
else
  sketchybar --set "$NAME" icon="$ICON_WIFI_OFF" icon.color=$DIM_COLOR label="Off"
fi
