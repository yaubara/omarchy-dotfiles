#!/bin/bash
#
# kbd_layout_colors.sh — Follow Mode: подсветка клавиатуры следует за раскладкой.
#   EN -> синий, RU -> красный. Состояние хранится в FLAG-файле.
#
# Подкоманды: toggle | sync [layout] | status | daemon
#   daemon запускается юнит-файлом kbd-layout-colors.service (systemd --user),
#   остальное дёргают виджет топ-бара и терминал. Цвет применяется через
#   kbd_backlight.sh (sysfs tuxedo-драйвера), daemon ничего лишнего не делает.

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
    pkill -RTMIN+1 waybar 2>/dev/null
    if [[ -f "$FLAG" ]]; then
        LAYOUT=${1:-$(read_layout)}
        if [[ "$LAYOUT" == *"English"* ]]; then
            kbd_backlight.sh color "$COLOR_EN" nosave
        elif [[ "$LAYOUT" == *"Russian"* ]]; then
            kbd_backlight.sh color "$COLOR_RU" nosave
        fi
    fi
}

log() {
    echo "$(date '+%F %T') $*"
}

run_daemon() {
    local instance="$HYPRLAND_INSTANCE_SIGNATURE"
    if [[ -z "$instance" ]]; then
        instance="$(hyprctl instances -j 2>/dev/null | jq -r '.[0].instance // empty' 2>/dev/null)"
    fi

    if [[ -z "$instance" ]]; then
        log "no Hyprland instance found; exiting"
        exit 1
    fi

    local SOCK="$XDG_RUNTIME_DIR/hypr/$instance/.socket2.sock"

    # At boot the Hyprland socket may not exist yet. Wait for it instead of dying:
    # the unit starts before Hyprland exports its instance signature.
    local i
    for i in $(seq 1 30); do
        [[ -S "$SOCK" ]] && break
        sleep 1
    done

    if [[ ! -S "$SOCK" ]]; then
        log "Hyprland socket $SOCK never appeared"
        exit 1
    fi

    log "watching $SOCK"
    sync_state
    socat -U - "UNIX-CONNECT:$SOCK" | while read -r line; do
        # Any layout switch: debounce, then re-read the source of truth instead of
        # trusting this event's payload (peripherals fire after and can disagree).
        [[ "$line" == activelayout\>\>* ]] || continue
        sleep 0.15
        sync_state
    done
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
        systemctl --user is-active kbd-layout-colors.service --quiet && echo "Daemon: RUNNING" || echo "Daemon: STOPPED"
        [[ -f "$FLAG" ]] && echo "Follow Mode: ON" || echo "Follow Mode: OFF"
        ;;
    daemon)
        run_daemon
        ;;
    -h|--help|*)
        echo "Usage: $(basename "$0") {toggle|sync|status|daemon}"
        ;;
esac
