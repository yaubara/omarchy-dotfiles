#!/usr/bin/env bash
# Fresh-machine bootstrap for these dotfiles (Omarchy / Arch).
#
# Run from a clone of the dotfiles repo (or from ~/.local/share/chezmoi):
#   ./scripts/bootstrap.sh
#
# Order matters: packages first (configs reference them), dotfiles last.
# Expects sudo prompts; run as a normal user, not root.
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
    echo "Run as a normal user (sudo prompts will be raised where needed)" >&2
    exit 1
fi

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

step() { echo; echo "=== $1 ==="; }

step "1/4 user apps (fonts, LSP, cursor)"
"$REPO/scripts/install-userapps.sh"

step "2/4 fan + keyboard-backlight stack (DKMS modules, TCC)"
"$REPO/scripts/setup-fan-control.sh"

step "3/4 voxtype GPU build + model"
"$REPO/scripts/setup-voxtype.sh"

step "4/4 dotfiles"
if command -v chezmoi >/dev/null; then
    # First time on a fresh machine this repo may not be the chezmoi source yet.
    if [[ "$(chezmoi sourcedir)" != "$REPO" ]]; then
        echo "Pointing chezmoi at $REPO ..."
        chezmoi init --source="$REPO"
    fi
    chezmoi apply -v
else
    echo "chezmoi not found — install it first: sudo pacman -S chezmoi" >&2
    exit 1
fi

# User services live outside dotfiles state — enable them explicitly.
step "user services"
systemctl --user enable --now kbd-layout-colors.service

echo
echo "Done. Open tuxedo-control-center, pick a cooling profile, then verify:"
echo "  sensors && kbd_layout_colors.sh status"
