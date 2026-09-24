#!/bin/bash

# ~/Scripts is on PATH via hypr/envs.lua, but this script is also invoked
# directly or from contexts (systemd, a bare terminal) that may not inherit it.
# Derive our own directory so kbd_backlight.sh always resolves as a fallback.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
case ":$PATH:" in
    *":$SCRIPT_DIR:"*) ;;
    *) export PATH="$SCRIPT_DIR:$PATH" ;;
esac

FLAG="$HOME/.cache/kbd_layout_follow"
COLOR_EN="0 0 255"
COLOR_RU="255 0 0"

# The layout you actually type on is the built-in keyboard. Peripherals (the
# gaming mouse's keypad, the RGB controller, buttons) each track their own
# index and can disagree, so they must not pick the color.
read_layout() {
    hyprctl devices -j | jq -r '
        [.keyboards[] | select(.name == "at-translated-set-2-keyboard") | .active_keymap] | first // ""
    '
}

sync_state() {
    pkill -RTMIN+1 waybar
    if [[ -f "$FLAG" ]]; then
        LAYOUT=${1:-$(read_layout)}
        if [[ "$LAYOUT" == *"English"* ]]; then
            kbd_backlight.sh color "$COLOR_EN" nosave
        elif [[ "$LAYOUT" == *"Russian"* ]]; then
            kbd_backlight.sh color "$COLOR_RU" nosave
        fi
    fi
}

stop_listener() {
    if [[ -f "$PID_FILE" ]]; then
        kill "$(cat "$PID_FILE")" && rm "$PID_FILE"
        pkill -f "socat.*socket2.sock"
        echo "Listener stopped."
    else
        echo "Listener is not running."
    fi
}

case "$1" in
    toggle)
        if [[ -f "$FLAG" ]]; then
            rm "$FLAG"
            kbd_backlight.sh restore
        else
            touch "$FLAG"
        fi
        sync_state
        ;;
    sync)
        sync_state "$2"
        ;;
    status)
        systemctl --user is-active kbd-layout-colors --quiet && echo "Daemon: RUNNING" || echo "Daemon: STOPPED"
        [[ -f "$FLAG" ]] && echo "Follow Mode: ON" || echo "Follow Mode: OFF"
        ;;
    -h|--help|*)
        echo "Usage: $(basename "$0") {toggle|sync|status}"
        ;;
esac