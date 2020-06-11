#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 1 ]]; then
    echo "Use a monitor name as parameter. Available:"
    polybar -m
    exit 1
fi

monitor="$1"
stylus="Wacom Intuos BT S Pen stylus"
pad="Wacom Intuos BT S Pad pad"

xsetwacom set "$stylus" MapToOutput "$monitor"

xsetwacom set "$pad" Button 1 "key +shift +control P -shift 1 -control"
xsetwacom set "$pad" Button 3 "key +control 2 -control"

xsetwacom set "$pad" touch on
xsetwacom set "$pad" Gesture on

