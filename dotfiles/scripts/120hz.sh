#!/usr/bin/env bash
set -euo pipefail

MONITOR="eDP-1"
HZ_LOW=60
HZ_HIGH=120

# Extract the block for the monitor
block=$(hyprctl monitors | awk -v mon="$MONITOR" '
  $0 ~ "^Monitor " mon "$" {capture=1}
  capture {print}
  capture && NF==0 {exit}
')

if [ -z "$block" ]; then
  echo "Monitor $MONITOR not found."
  exit 1
fi

# Parse width, height, refresh
width=$(echo "$block"  | awk '/width:/  {print $2}')
height=$(echo "$block" | awk '/height:/ {print $2}')
refresh=$(echo "$block" | awk '/refreshRate:/ {print int($2)}')

if [ -z "$width" ] || [ -z "$height" ] || [ -z "$refresh" ]; then
  echo "Failed to parse monitor info."
  exit 1
fi

# Decide next refresh rate
if [ "$refresh" -ge $(( (HZ_LOW + HZ_HIGH) / 2 )) ]; then
  target=$HZ_LOW
else
  target=$HZ_HIGH
fi

# Apply the mode
hyprctl keyword monitor "$MONITOR,${width}x${height}@${target},0x0,1"

