#!/usr/bin/env bash
# Fan + keyboard-backlight stack for Clevo-based laptops (e.g. Gigabyte G5/G7).
#
# Installs: clevo-drivers-dkms-git (kernel modules) and tuxedo-control-center-bin
# (userspace GUI + tccd daemon). Re-run on a fresh machine after the base
# Omarchy system is up, or after reinstalling either package.
#
# Do NOT install clevo-xsm-wmi (abandoned, conflicts) or clevo-indicator
# (outdated, unsafe direct EC access). gigabyte-laptop-wmi does not support
# pre-2025 Gaming models (G5/G7 are rebadged Clevo — use this stack instead).
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
    echo "Run as a normal user (sudo prompts will be raised where needed)" >&2
    exit 1
fi

# 1. Kernel headers — DKMS cannot build without them. Omarchy runs its own
#    kernel (linux-omarchy), so the vanilla linux-headers package is wrong here.
if ! pacman -Qqo "/lib/modules/$(uname -r)/build" >/dev/null 2>&1; then
    echo "Installing kernel headers for $(uname -r)..."
    sudo pacman -S --needed linux-omarchy-headers
fi

# 2. Driver (kernel modules: clevo_acpi, tuxedo_io, tuxedo_keyboard, ...) and
#    userspace control center. Prefer the Omarchy wrapper (uses yay under
#    the hood); fall back to yay directly if the wrapper is unavailable.
if command -v omarchy >/dev/null && omarchy pkg aur accessible >/dev/null 2>&1; then
    omarchy pkg aur add clevo-drivers-dkms-git tuxedo-control-center-bin
else
    command -v yay >/dev/null || { echo "yay not found — install it first" >&2; exit 1; }
    yay -S --needed clevo-drivers-dkms-git tuxedo-control-center-bin
fi

# 3. Non-Tuxedo Clevo hardware needs the unsupported-hardware escape hatch,
#    otherwise tuxedo_keyboard refuses to bind and there is no backlight/fan IO.
CONF=/etc/modprobe.d/tuxedo_keyboard.conf
if ! grep -q "force_unsupported=1" "$CONF" 2>/dev/null; then
    echo "Enabling force_unsupported for non-Tuxedo Clevo hardware..."
    echo "options tuxedo_keyboard mode=0 force_unsupported=1" | sudo tee "$CONF" >/dev/null
    echo "NOTE: reboot so the module reloads with the new option."
fi

# 4. Daemon on (the unit is tccd, not tuxedofancontrol) and sanity checks.
sudo systemctl enable --now tccd.service tccd-sleep.service

echo "--- sanity checks ---"
dkms status | grep -E "clevo-drivers" || { echo "WARNING: clevo-drivers DKMS not built" >&2; }
lsmod | grep -q tuxedo_io && echo "tuxedo_io loaded" || echo "WARNING: tuxedo_io not loaded (reboot?)" >&2
[[ -e /dev/tuxedo_io ]] && echo "/dev/tuxedo_io present" || echo "WARNING: /dev/tuxedo_io missing" >&2

echo "Done. Open tuxedo-control-center, pick a cooling profile, and verify"
echo "with: sensors"
