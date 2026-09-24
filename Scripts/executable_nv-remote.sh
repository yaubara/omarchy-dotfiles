#!/bin/sh

# 1. Split the string by the LAST colon to get the file path
# This handles files that might have colons in their names (rare but possible)
FILE=$(echo "$1" | sed 's/:[0-9]\+:[0-9]\+$//' | sed 's/:[0-9]\+$//')
LINE=$(echo "$1" | grep -oE ':[0-9]+' | head -n 1 | tr -d ':')

# 2. Default to line 1 if no line number was found
[ -z "$LINE" ] && LINE=1

if [ -n "$NVIM" ]; then
    # 3. Use nvim --remote-expr to handle the file path as a quoted string
    # We use fnameescape inside the remote expression for absolute safety
    nvim --server "$NVIM" --remote-send "<C-\><C-n>:execute 'edit ' . fnameescape('$FILE')<CR>:$LINE<CR>"
else
    # Fallback for external terminals (standard nvim handles spaces via "$FILE")
    nvim "+$LINE" "$FILE"
fi
