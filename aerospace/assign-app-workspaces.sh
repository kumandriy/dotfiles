#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# assign-app-workspaces.sh  (Script 2 — replay, for after-startup-command)
#
# Reads the map produced by dump-app-assignments.sh and, for every currently
# open window, moves it to its saved workspace and restores its saved layout
# (floating vs tiling). Unknown apps (not in the map) are left untouched.
#
# Wire into aerospace.toml:
#   after-startup-command = [
#     'exec-and-forget /Users/kumandriy/.config/aerospace/assign-app-workspaces.sh',
#   ]
#
# Env overrides:
#   AEROSPACE_BIN       path to the aerospace CLI   (default: homebrew)
#   AEROSPACE_MAP_FILE  map to read                 (default: config folder)
# ---------------------------------------------------------------------------
set -euo pipefail

AEROSPACE="${AEROSPACE_BIN:-/opt/homebrew/bin/aerospace}"
MAP_FILE="${AEROSPACE_MAP_FILE:-$HOME/.config/aerospace/app-workspace.map}"

[[ -r "$MAP_FILE" ]] || { echo "No map file at $MAP_FILE" >&2; exit 0; }

# bundle-id -> target workspace / layout
declare -A ws_of layout_of
while IFS=$'\t' read -r ws bundle layout _name; do
  [[ -n "${bundle:-}" ]] || continue
  ws_of["$bundle"]="$ws"
  layout_of["$bundle"]="$layout"
done < "$MAP_FILE"

# Walk current windows; move + restore layout for the ones we know about.
while IFS=$'\t' read -r wid bundle; do
  ws="${ws_of[$bundle]:-}"
  [[ -n "$ws" ]] || continue
  "$AEROSPACE" move-node-to-workspace --window-id "$wid" "$ws" || true
  lay="${layout_of[$bundle]:-}"
  [[ -n "$lay" ]] && "$AEROSPACE" layout "$lay" --window-id "$wid" || true
done < <("$AEROSPACE" list-windows --all --format '%{window-id}%{tab}%{app-bundle-id}')
