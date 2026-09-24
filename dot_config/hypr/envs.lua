-- Extra env variables (restored from the pre-4.0 envs.conf).
hl.env("SSH_AUTH_SOCK", os.getenv("XDG_RUNTIME_DIR") .. "/ssh-agent.socket")

-- Cursor
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")

-- Custom scripts directory. Single source of truth: rename the folder once,
-- update SCRIPTS_DIR here, and autostart.lua / the daemon / the widget resolve it.
hl.env("SCRIPTS_DIR", os.getenv("HOME") .. "/Scripts")

-- Add scripts to path (was dropped by the 4.0 upgrade)
hl.env("PATH", (os.getenv("PATH") or "") .. ":" .. os.getenv("SCRIPTS_DIR"))