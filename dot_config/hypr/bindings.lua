-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- App bindings
o.bind("SUPER + SHIFT + T", "Telegram", { launch = "Telegram", focus = "Telegram" })
o.bind("SUPER + ALT + RETURN", "Tmux", { omarchy = "terminal-tmux" })
o.bind("SUPER + SHIFT + D", "Docker", { tui = "omarchy-launch-docker-tui" })
o.bind("SUPER + SHIFT + O", "Obsidian", { launch = "obsidian", focus = "^obsidian$" })
o.bind("SUPER + SHIFT + M", "SoundCloud", { webapp = "https://soundcloud.com/you/library", focus = true })

-- Agents
hl.unbind("SUPER + SHIFT + CTRL + A")
o.bind("SUPER + A", "Agent", "omarchy-agent --pick")
o.bind("SUPER + SHIFT + A", "Herdr", { omarchy = "terminal-herdr" })
o.bind("SUPER + SHIFT + CTRL + A", "Herdr keybindings", "omarchy-menu-herdr-keybindings")

-- Clipboard history: SUPER+SHIFT+V opens searchable clipboard overlay (was SUPER+CTRL+V)
hl.unbind("SUPER + CTRL + V")
o.bind("SUPER + SHIFT + V", "Clipboard manager", "omarchy-shell shell toggle omarchy.clipboard")

-- Dictation: SUPER+D toggles voxtype recording (was SUPER+CTRL+X)
hl.unbind("SUPER + CTRL + X")
o.bind("SUPER + D", "Toggle Voxtype", "voxtype record toggle")

-- Lock system
o.bind("SUPER + Q", "Lock system", "omarchy-system-lock")

-- Hardware menu to enable / disable hybrid gpu, touchpad, external monitor etc, maybe not needed
-- o.bind("SUPER + CTRL + H", "Hardware menu", "omarchy-menu toggle hardware")

-- Screenshot
o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")

-- Commands cheatsheet
hl.unbind("SUPER + SLASH")
o.bind("SUPER + SLASH", "Keybindings", "omarchy-menu-keybindings")

-- Monitor scaling: SUPER+ / SUPER-
hl.unbind("SUPER + ALT + SLASH")
o.bind("SUPER + PLUS", "Monitor scaling up", "omarchy-hyprland-monitor-scaling up")
o.bind("SUPER + MINUS", "Monitor scaling down", "omarchy-hyprland-monitor-scaling down")

-- Vim-letter window navigation
hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")

hl.unbind("SUPER + CTRL + H") -- was: Hardware menu
hl.unbind("SUPER + CTRL + K") -- was: Herdr keybindings
hl.unbind("SUPER + CTRL + L") -- was: Lock system

o.bind("SUPER + H", "Move focus left", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Move focus down", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Move focus up", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Move focus right", hl.dsp.focus({ direction = "r" }))

-- Toggle split orientation (vertical/horizontal) for the focused tile
o.bind("SUPER + SHIFT + P", "Toggle window split", hl.dsp.layout("togglesplit"))

-- Vim-style resize of the focused tile (100px steps)
o.bind("SUPER + CTRL + H", "Resize window left", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
o.bind("SUPER + CTRL + J", "Resize window down", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))
o.bind("SUPER + CTRL + K", "Resize window up", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
o.bind("SUPER + CTRL + L", "Resize window right", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))

o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))

o.bind("SUPER + ALT + H", "Move window to group on left", hl.dsp.window.move({ into_group = "l" }))
o.bind("SUPER + ALT + J", "Move window to group on bottom", hl.dsp.window.move({ into_group = "d" }))
o.bind("SUPER + ALT + K", "Move window to group on top", hl.dsp.window.move({ into_group = "u" }))
o.bind("SUPER + ALT + L", "Move window to group on right", hl.dsp.window.move({ into_group = "r" }))

-- RGB keyboard backlight via custom scripts (pre-4.0 bindings.conf). The
-- SCRIPTS_DIR env is set by hypr/envs.lua (single source for the scripts dir).
local kbd = os.getenv("SCRIPTS_DIR") .. "/kbd_backlight.sh"
hl.unbind("XF86KbdBrightnessUp")
hl.unbind("XF86KbdBrightnessDown")
hl.unbind("XF86KbdLightOnOff")
o.bind("XF86KbdBrightnessUp", "Keyboard brightness up", kbd .. " up", { locked = true, repeating = true })
o.bind("XF86KbdBrightnessDown", "Keyboard brightness down", kbd .. " down", { locked = true, repeating = true })
o.bind("XF86KbdLightOnOff", "Keyboard backlight toggle", kbd .. " toggle", { locked = true })
o.bind("F24", "Keyboard backlight color cycle", kbd .. " cycle")
