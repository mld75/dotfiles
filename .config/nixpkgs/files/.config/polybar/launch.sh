#!/usr/bin/env sh

# Terminate already running bar instances
killall -q -r -w polybar

# Wait until the processes have been shut down
while pgrep polybar >/dev/null; do sleep 1; done

# Launch
for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar top &
done

echo "Bar launched..."
