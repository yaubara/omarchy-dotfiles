#!/bin/bash
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

apply() {
    [[ -f "$FLAG" ]] || return 0
    local LAYOUT
    LAYOUT=$(read_layout)
    if [[ "$LAYOUT" == *"English"* ]]; then
        kbd_backlight.sh color "$COLOR_EN" nosave
    elif [[ "$LAYOUT" == *"Russian"* ]]; then
        kbd_backlight.sh color "$COLOR_RU" nosave
    fi
}

# watchers wait for the socket to exist; log the socket for debugging.
log() {
    echo "$(date '+%F %T') $*"
}

# Make sure the scripts dir (where kbd_backlight.sh lives) is reachable. The
# systemd unit may not inherit Hyprland's envs.lua PATH, so add it here; the
# SCRIPTS_DIR env (set by hypr/envs.lua) is the single source, with a fallback
# for contexts that predate it.
# shellcheck disable=SC2086
export PATH="${SCRIPTS_DIR:-$HOME/Scripts}:$PATH"

instance="$(hyprctl instances -j 2>/dev/null | jq -r '.[0].instance // empty' 2>/dev/null)"
if [[ -z "$instance" ]]; then
    instance="$HYPRLAND_INSTANCE_SIGNATURE"
fi

if [[ -z "$instance" ]]; then
    log "no Hyprland instance found; exiting"
    exit 1
fi

SOCK="$XDG_RUNTIME_DIR/hypr/$instance/.socket2.sock"

# At boot the Hyprland socket may not exist yet. Wait for it instead of dying:
# the unit starts before Hyprland exports its instance signature.
for _ in $(seq 1 30); do
    [[ -S "$SOCK" ]] && break
    sleep 1
done

if [[ ! -S "$SOCK" ]]; then
    log "Hyprland socket $SOCK never appeared"
    exit 1
fi

log "watching $SOCK"
apply
socat -U - "UNIX-CONNECT:$SOCK" | while read -r line; do
    # Any layout switch: debounce, then re-read the source of truth instead of
    # trusting this event's payload (peripherals fire after and can disagree).
    [[ "$line" == activelayout\>\>* ]] || continue
    sleep 0.15
    apply
done