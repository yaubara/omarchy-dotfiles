# Omarchy Dotfiles

Personal configuration for Arch Linux + Omarchy (Hyprland, Wayland), managed
with [chezmoi](https://www.chezmoi.io/). Also includes my neovim config.

## Setup on a fresh machine

```sh
# 1. Install chezmoi
sudo pacman -S chezmoi

# 2. Apply dotfiles (interactive: shows diff, asks to confirm)
chezmoi init git@github.com:yaubara/omarchy-dotfiles.git
chezmoi apply -v
```

Or in one shot: `chezmoi init --apply git@github.com:yaubara/omarchy-dotfiles.git`

## Package notes (not included in the repo)

Installed via `scripts/install-userapps.sh` / setup scripts:

| What | How | Why |
|---|---|---|
| Cursor theme `Bibata-Modern-Ice` | `yay -S bibata-cursor-theme-bin` | set via `hypr/envs.lua` (`XCURSOR_THEME`) |
| `JetBrainsMono Nerd Font` | `pacman -S ttf-jetbrains-mono-nerd-basic` | used by foot |
| `codebook-lsp` | `pacman -S codebook-lsp` | LSP server for the codebook spell-checker |
| Custom Scripts | `Scripts/` in this repo | misc system scripts: keyboard backlight RGB, layout colors, wallpaper toggle, etc. |

## Fans & keyboard backlight (Gigabyte G5 MF, Clevo-based)

Hardware control stack (packages, not dotfiles — reinstall on a fresh machine):

| What | How | Why |
|---|---|---|
| `clevo-drivers-dkms-git` (AUR) | `omarchy pkg aur add clevo-drivers-dkms-git` | kernel modules (`clevo_acpi`, `tuxedo_io`, `tuxedo_keyboard`); with `force_unsupported=1` on non-Tuxedo Clevo |
| `tuxedo-control-center-bin` (AUR) | `omarchy pkg aur add tuxedo-control-center-bin`, then `sudo systemctl enable --now tccd.service tccd-sleep.service` | fan curves/profiles GUI + daemon. The service is `tccd`, not `tuxedofancontrol` |

Follow Mode (keyboard color follows layout, EN=blue / RU=red): `Scripts/kbd_layout_colors.sh`
(`toggle|sync|status|daemon`) + user service `dot_config/systemd/user/kbd-layout-colors.service`,
toggled from the top-bar widget (`yaubara.keyboard-layout`, right-click). Brightness Fn-keys
are bound in `hypr/bindings.lua` to `Scripts/kbd_backlight.sh` — TCC adds no Hyprland bindings.

Notes: TCC applies its own stored backlight state on start/profile switch
(`keyboardBacklightControlEnabled` in `/etc/tcc/settings`), which overrides the Follow Mode
color until the next layout switch. Do NOT install `clevo-xsm-wmi` (abandoned, conflicts)
or `clevo-indicator` (outdated, unsafe direct EC access); `gigabyte-laptop-wmi` does not
support pre-2025 Gaming models (G5/G7 are rebadged Clevo).

## Voxtype (NVIDIA GPU)

The GPU-vs-CPU build of voxtype is NOT a config file. `sudo voxtype setup gpu --enable`
repoints the `/usr/bin/voxtype` symlink to the Vulkan build. Reproduce it with:

```sh
./scripts/setup-voxtype.sh   # sudo voxtype setup gpu --enable + model + systemd unit
```

`~/.config/systemd/user/voxtype.service` pins Vulkan to the discrete NVIDIA GPU
(RTX 4050) with `VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json`, so
Whisper (large-v3-turbo) loads on the NVIDIA GPU instead of the Intel iGPU.

## Limine

Kernel command line lives in `/etc/default/limine` (template: `etc/default/limine`
in this repo). See that file for the NVIDIA/PCI-e custom flags; `root=PARTUUID=…`
must be adjusted per machine.


