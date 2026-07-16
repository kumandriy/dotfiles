#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# dump-app-assignments.sh  (Script 1 — one-shot capture)
#
# Snapshots the CURRENT app -> workspace layout and writes it to a map file
# that assign-app-workspaces.sh can replay later (from after-startup-command
# or via the service-mode hotkey wrapper).
#
# Output format (tab-separated, one line per app):
#     <workspace>\t<app-bundle-id>\t<layout>\t<app-name>
#
# <layout> is normalized to either "floating" or "tiling" so the replay can
# restore whether an app floats. NOTE: this is the ONLY layout attribute the
# AeroSpace CLI exposes — window geometry, split ratios, and tiling order are
# not reported by `list-windows` and therefore cannot be captured/restored.
#
# An app may have windows on several workspaces / in different layouts; we
# keep the FIRST window seen for each bundle-id so every app maps to exactly
# one workspace + one layout.
#
# Env overrides:
#   AEROSPACE_BIN       path to the aerospace CLI   (default: homebrew)
#   AEROSPACE_MAP_FILE  where to write the map      (default: config folder)
# ---------------------------------------------------------------------------
set -euo pipefail

AEROSPACE="${AEROSPACE_BIN:-/opt/homebrew/bin/aerospace}"
MAP_FILE="${AEROSPACE_MAP_FILE:-$HOME/.config/aerospace/app-workspace.map}"

"$AEROSPACE" list-windows --all \
  --format '%{workspace}%{tab}%{app-bundle-id}%{tab}%{window-layout}%{tab}%{app-name}' \
  | awk -F '\t' 'NF && !seen[$2]++ {
        layout = ($3 == "floating") ? "floating" : "tiling"
        print $1 "\t" $2 "\t" layout "\t" $4
      }' \
  > "$MAP_FILE"

printf 'Saved %s app assignments to %s\n' \
  "$(wc -l < "$MAP_FILE" | tr -d ' ')" "$MAP_FILE"
cat "$MAP_FILE"
