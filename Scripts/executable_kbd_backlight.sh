#!/bin/bash

BRIGHTNESS_PATH="/sys/class/leds/rgb:kbd_backlight/brightness"
COLOR_PATH="/sys/class/leds/rgb:kbd_backlight/multi_intensity"
MAX_BRIGHT_PATH="/sys/class/leds/rgb:kbd_backlight/max_brightness"
STATE_FILE="$HOME/.kbd_backlight_state"

# --- Настройка цветов ---
COLORS=(
    "255 255 255" # Белый
    "255 0 0"     # Красный
    "0 255 0"     # Зеленый
    "0 0 255"     # Синий
    "255 255 0"   # Желтый
    "255 0 255"   # Фиолетовый
    "0 255 255"   # Циан
)

REAL_BRIGHT=$(cat "$BRIGHTNESS_PATH")
MAX_BRIGHT=$(cat "$MAX_BRIGHT_PATH")
STEP=25

# Читаем старое состояние
if [ -f "$STATE_FILE" ]; then
    SAVED_VALS=$(cat "$STATE_FILE")
    B_VAL=$(echo "$SAVED_VALS" | cut -d'|' -f1)
    C_VAL=$(echo "$SAVED_VALS" | cut -d'|' -f2)
else
    B_VAL=$MAX_BRIGHT
    C_VAL=${COLORS[0]}
fi

save_state() {
    local bright=$1
    local color=$2
    [ -z "$color" ] && color=$(cat "$COLOR_PATH")
    
    if [ "$bright" -gt 0 ]; then
        echo -n "$bright|$color" > "$STATE_FILE"
    fi
}

apply_settings() {
    local b=$1
    local c=$2
    [ -n "$c" ] && echo "$c" > "$COLOR_PATH"
    sleep 0.02
    echo "$b" > "$BRIGHTNESS_PATH"
}

case "$1" in
    up)
        NEW=$((REAL_BRIGHT + STEP))
        [ "$NEW" -gt "$MAX_BRIGHT" ] && NEW="$MAX_BRIGHT"
        apply_settings "$NEW" "$C_VAL"
        save_state "$NEW" "$C_VAL"
        ;;
    down)
        NEW=$((REAL_BRIGHT - STEP))
        [ "$NEW" -lt 0 ] && NEW=0
        apply_settings "$NEW" "$C_VAL"
        save_state "$NEW" "$C_VAL"
        ;;
    off)
        save_state "$REAL_BRIGHT" "$C_VAL"
        echo 0 > "$BRIGHTNESS_PATH"
        ;;
    on|restore)
        [[ -z "$B_VAL" || "$B_VAL" -eq 0 ]] && B_VAL=$MAX_BRIGHT
        apply_settings "$B_VAL" "$C_VAL"
        ;;
    toggle)
        if [ "$REAL_BRIGHT" -gt 0 ]; then
            save_state "$REAL_BRIGHT" "$C_VAL"
            echo 0 > "$BRIGHTNESS_PATH"
        else
            [[ -z "$B_VAL" || "$B_VAL" -eq 0 ]] && B_VAL=$MAX_BRIGHT
            apply_settings "$B_VAL" "$C_VAL"
        fi
        ;;
    cycle)
        CURRENT_INDEX=-1
        for i in "${!COLORS[@]}"; do
           if [[ "${COLORS[$i]}" == "$C_VAL" ]]; then
               CURRENT_INDEX=$i
               break
           fi
        done
        NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#COLORS[@]} ))
        NEXT_COLOR=${COLORS[$NEXT_INDEX]}
        [[ "$REAL_BRIGHT" -eq 0 ]] && REAL_BRIGHT=$B_VAL
        [[ "$REAL_BRIGHT" -eq 0 ]] && REAL_BRIGHT=$MAX_BRIGHT
        apply_settings "$REAL_BRIGHT" "$NEXT_COLOR"
        save_state "$REAL_BRIGHT" "$NEXT_COLOR"
        ;;
    color)
        apply_settings "$REAL_BRIGHT" "$2"
        # Сохраняем ТОЛЬКО если третьим параметром НЕ передано "nosave"
        if [ "$3" != "nosave" ]; then
            save_state "$REAL_BRIGHT" "$2"
        fi
        ;;
    *)
        echo "Usage: $0 {up|down|on|off|toggle|cycle|color 'R G B' [nosave]}"
        exit 1
        ;;
esac
