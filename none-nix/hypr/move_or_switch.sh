#!/usr/bin/env bash
set -euo pipefail

direction="$1"

# Map directions to movement parameters
declare -A WS_MOVE=( [left]=-1 [right]=+1 [up]=-1 [down]=+1 )
declare -A AXIS=( [left]=x [right]=x [up]=y [down]=y )
declare -A SHORT=( [left]=l [right]=r [up]=u [down]=d )

# Validate argument
if [[ -z "${WS_MOVE[$direction]:-}" ]]; then
  echo "Usage: $0 {left|right|up|down}" >&2
  exit 1
fi

# Get window geometry (x, y, width, height)
read -r win_x win_y win_w win_h < <(
  hyprctl activewindow -j |
    jq -r '[.at[0], .at[1], .size[0], .size[1]] | @tsv'
)

# Get monitor geometry for current workspace
ws_monitor=$(hyprctl activeworkspace -j | jq -r '.monitor')
read -r ws_x ws_y ws_w ws_h < <(
  hyprctl monitors -j |
    jq -r --arg mon "$ws_monitor" '
      .[] | select(.name == $mon) | [.x, .y, .width, .height] | @tsv
    '
)

# Margin in pixels
MARGIN=30

# Determine if window is at the edge
at_edge=0
axis=${AXIS[$direction]}

if [[ $axis == x ]]; then
  if [[ $direction == left ]]; then
    (( win_x - ws_x <= MARGIN )) && at_edge=1
  else  # right
    (( (win_x + win_w) - (ws_x + ws_w) >= -MARGIN )) && at_edge=1
  fi
else
  if [[ $direction == up ]]; then
    (( win_y - ws_y <= MARGIN )) && at_edge=1
  else  # down
    (( (win_y + win_h) - (ws_y + ws_h) >= -MARGIN )) && at_edge=1
  fi
fi

# Dispatch the appropriate action
if (( at_edge )); then
  hyprctl dispatch movetoworkspace "${WS_MOVE[$direction]}"
else
  hyprctl dispatch movewindow "${SHORT[$direction]}"
fi
