#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# save-assignments.sh  (Script 3 — service-mode hotkey wrapper)
#
# Runs dump-app-assignments.sh and pops a macOS notification with the result,
# so you can re-capture your current layout from AeroSpace service mode.
#
# Wire into aerospace.toml [mode.service.binding], e.g.:
#   s = ['exec-and-forget /Users/kumandriy/.config/aerospace/save-assignments.sh', 'mode main']
# ---------------------------------------------------------------------------
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if out="$("$DIR/dump-app-assignments.sh" 2>&1)"; then
  count="$(printf '%s\n' "$out" | sed -n 's/^Saved \([0-9][0-9]*\).*/\1/p')"
  /usr/bin/osascript -e "display notification \"Captured ${count:-?} app assignments\" with title \"AeroSpace\" sound name \"Tink\""
else
  /usr/bin/osascript -e "display notification \"Failed to capture assignments\" with title \"AeroSpace\" sound name \"Basso\""
  exit 1
fi
