#!/bin/bash
# Copyright (C) 2025 choozn
# Installation script for optional software bundle

echo "[!] Started installation of the optional software bundle."

# Request sudo privileges
sudo -v || { echo "[!] Failed to gain sudo access."; exit 1; }
echo ""

# Install optional other software
sudo pacman --noconfirm --needed -S filelight gimp libreoffice-still obsidian syncthing vlc thunderbird cheese zathura zathura-pdf-mupdf || { echo "[!] Failed to install optional software (1). Exiting."; exit 1; }
yay --noconfirm --needed -S zen-browser-bin ungoogled-chromium-bin proton-vpn-gtk-app localsend-bin tex-match || { echo "[!] Failed to install optional software (2). Exiting."; exit 1; }

# Speed up start time for browsers
sudo pacman --noconfirm --needed -S profile-sync-deamon
yay --noconfirm --needed -S profile-sync-deamon-zen
ln -s "$HOME/.config/hypr/psd/psd.conf" "$HOME/.config/psd/" -f || { echo "[!] Failed to link psd config. Exiting."; exit 1; }
systemctl --user enable psd
systemctl --user start psd

# Start syncthing
systemctl --user enable syncthing
systemctl --user start syncthing
syncthing --browser-only

# Link zathura config
ln -s "$HOME/.config/hypr/zathura/zathurarc" "$HOME/.config/zathura/" || { echo "[!] Failed to link zathura config. Exiting."; exit 1; }

echo -e "\n[!] Installation successful!"
