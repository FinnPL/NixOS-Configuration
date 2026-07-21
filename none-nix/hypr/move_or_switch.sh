#!/usr/bin/env bash
set -euo pipefail

# Usage: move_or_switch.sh <mode> <direction> [workspaces_per_monitor]
#   mode:        move | switch | monitor
#   direction:   left | right | up | down
#   workspaces_per_monitor: size of each monitor's workspace group.
#                0 (or omitted) = global behaviour (single-monitor / laptop).
#
#   move    - move the active window: between tiles, and at a horizontal edge
#             to the previous/next workspace *within the current monitor*.
#   switch  - switch to the previous/next workspace within the current monitor.
#   monitor - move the active window to the adjacent monitor.

mode="${1:?Usage: $0 <move|switch|monitor> <left|right|up|down> [per_monitor]}"
direction="${2:?Usage: $0 <move|switch|monitor> <left|right|up|down> [per_monitor]}"
per_mon="${3:-0}"

# --- monitor mode: push the window to the neighbouring monitor -------------
if [[ "$mode" == "monitor" ]]; then
  case "$direction" in
    left)  hyprctl dispatch movewindow mon:l ;;
    right) hyprctl dispatch movewindow mon:r ;;
    up)    hyprctl dispatch movewindow mon:u ;;
    down)  hyprctl dispatch movewindow mon:d ;;
    *) echo "Unknown direction: $direction" >&2; exit 1 ;;
  esac
  exit 0
fi

current_ws=$(hyprctl activeworkspace -j | jq -r '.id')

# Target workspace when moving/switching left(prev) or right(next).
# Wraps within the current monitor's group when per_mon > 0, otherwise
# falls back to a global relative move (+1 / -1).
target_ws() {
  local dir="$1" # prev | next
  if (( per_mon > 0 )); then
    local group=$(( (current_ws - 1) / per_mon ))
    local lo=$(( group * per_mon + 1 ))
    local hi=$(( lo + per_mon - 1 ))
    if [[ "$dir" == "prev" ]]; then
      (( current_ws <= lo )) && echo "$hi" || echo $(( current_ws - 1 ))
    else
      (( current_ws >= hi )) && echo "$lo" || echo $(( current_ws + 1 ))
    fi
  else
    [[ "$dir" == "prev" ]] && echo "-1" || echo "+1"
  fi
}

# --- switch mode: just change workspace within the monitor -----------------
if [[ "$mode" == "switch" ]]; then
  case "$direction" in
    left)  hyprctl dispatch workspace "$(target_ws prev)" ;;
    right) hyprctl dispatch workspace "$(target_ws next)" ;;
    *) echo "switch only supports left/right" >&2; exit 1 ;;
  esac
  exit 0
fi

# --- move mode: tile-aware window move with edge detection -----------------
declare -A SHORT=( [left]=l [right]=r [up]=u [down]=d )
declare -A AXIS=( [left]=x [right]=x [up]=y [down]=y )

# Get active window geometry (x, y, width, height)
read -r win_x win_y win_w win_h < <(
  hyprctl activewindow -j |
    jq -r '[.at[0], .at[1], .size[0], .size[1]] | @tsv'
)

# Get monitor geometry for the current workspace
ws_monitor=$(hyprctl activeworkspace -j | jq -r '.monitor')
read -r ws_x ws_y ws_w ws_h < <(
  hyprctl monitors -j |
    jq -r --arg mon "$ws_monitor" '
      .[] | select(.name == $mon) | [.x, .y, .width, .height] | @tsv
    '
)

MARGIN=30
WAYBAR_HEIGHT=40

at_edge=0
axis=${AXIS[$direction]}

if [[ $axis == x ]]; then
  if [[ $direction == left ]]; then
    (( win_x - ws_x <= MARGIN )) && at_edge=1
  else
    (( (win_x + win_w) - (ws_x + ws_w) >= -MARGIN )) && at_edge=1
  fi
else
  if [[ $direction == up ]]; then
    (( win_y - (ws_y + WAYBAR_HEIGHT) <= MARGIN )) && at_edge=1
  else
    (( (win_y + win_h) - (ws_y + ws_h) >= -MARGIN )) && at_edge=1
  fi
fi

if (( at_edge )); then
  if [[ $axis == x ]]; then
    # At a horizontal edge: move window to prev/next workspace on this monitor
    if [[ $direction == left ]]; then
      hyprctl dispatch movetoworkspace "$(target_ws prev)"
    else
      hyprctl dispatch movetoworkspace "$(target_ws next)"
    fi
  else
    # At a vertical edge: toggle the split orientation
    hyprctl dispatch layoutmsg "togglesplit"
  fi
else
  hyprctl dispatch movewindow "${SHORT[$direction]}"
fi
