#!/bin/bash

FLAG="$HOME/.cache/kbd_layout_follow"
LAYOUT=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap')

if [[ "$LAYOUT" == *"English"* ]]; then
    ICON="🇺🇸"
    CLASS="en"
else
    ICON="🇷🇺"
    CLASS="ru"
fi

# Add a visual hint if the Keyboard Light Follow feature is ON
if [[ -f "$FLAG" ]]; then
    TEXT="$ICON ✨"
    TOOLTIP="Layout Follow: ON"
else
    TEXT="$ICON"
    TOOLTIP="Layout Follow: OFF"
fi

printf '{"text":"%s", "tooltip":"%s", "class":"%s"}\n' "$TEXT" "$TOOLTIP" "$CLASS"

