# Omarchy Dotfiles

Personal configuration for Arch Linux + Omarchy (Hyprland, Wayland), managed
with [chezmoi](https://www.chezmoi.io/).

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

## Fish shell

`dot_config/fish/config.fish` — docker compose abbreviations, `unbind.fish` maps
`ctrl-j` to `true`. After setup re-add paths (fish universal vars are machine state):

```sh
fish_add_path ~/Scripts ~/.local/bin
```
