#!/bin/bash

if pgrep -f "$(basename "$0")" | grep -v -q "^$$$"; then
    exit 0
fi

BRIGHTNESS_PATH="/sys/class/leds/rgb:kbd_backlight/brightness"
MIN=10
MAX=255
STEP=5
DELAY=0.03

restore_on_exit() {
    kbd_backlight.sh restore
    exit
}
trap restore_on_exit SIGINT SIGTERM EXIT

while true; do
    # Fade Up
    for ((i=MIN; i<=MAX; i+=STEP)); do
        echo "$i" > "$BRIGHTNESS_PATH"
        sleep "$DELAY"
    done
    echo "$MAX" > "$BRIGHTNESS_PATH" # Гарантируем чистые 255 в пике

    # Fade Down
    for ((i=MAX; i>=MIN; i-=STEP)); do
        echo "$i" > "$BRIGHTNESS_PATH"
        sleep "$DELAY"
    done
    echo "$MIN" > "$BRIGHTNESS_PATH" # Гарантируем чистые 10 внизу
done
