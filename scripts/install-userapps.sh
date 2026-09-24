#!/usr/bin/env bash
# Packages needed by the dotfiles that live outside ~/.config or the AUR.
# Install after the base Omarchy system and before chezmoi apply.
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
    echo "Run as a normal user (sudo prompts will be raised by pacman)" >&2
    exit 1
fi

# Official repositories
sudo pacman -S --needed \
    ttf-jetbrains-mono-nerd-basic \
    codebook-lsp

# AUR (via yay)
command -v yay >/dev/null || { echo "yay not found — install it first" >&2; exit 1; }
yay -S --needed \
    bibata-cursor-theme-bin