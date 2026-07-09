#!/usr/bin/env bash
CPU_IDLE="$(top -l 1 -n 0 | grep 'CPU usage' | awk -F', ' '{print $3}' | tr -d '% idle')"
[ -z "$CPU_IDLE" ] && exit 0
CPU_USED=$(( 100 - ${CPU_IDLE%.*} ))
sketchybar --set "$NAME" label="${CPU_USED}%"
