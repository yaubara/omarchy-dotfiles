#!/usr/bin/env bash
# Pin voxtype to the NVIDIA Vulkan build and fetch the transcription model.
#
# The GPU-vs-CPU build is NOT a config file: `sudo voxtype setup gpu --enable`
# repoints the /usr/bin/voxtype symlink between the avx2 and vulkan builds.
# Re-run this after reinstalling the voxtype package, or on a fresh machine.
set -euo pipefail

sudo voxtype setup gpu --enable
voxtype setup --download --model large-v3-turbo

# Start the push-to-talk daemon for the graphical session and enable it.
# (Vulkan model load requires the NVIDIA ICD override in
#  ~/.config/systemd/user/voxtype.service: VK_ICD_FILENAMES=nvidia_icd.json)
systemctl --user enable --now voxtype