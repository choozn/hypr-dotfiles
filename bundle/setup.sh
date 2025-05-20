#!/bin/bash
# Copyright (C) 2025 choozn
# Installation script for optional software bundle

echo "[!] Started installation of the optional software bundle."

# Request sudo privileges
sudo -v || { echo "[!] Failed to gain sudo access."; exit 1; }
echo ""

# Install optional other software
sudo pacman --noconfirm --needed -S filelight gimp libreoffice-still obsidian syncthing vlc thunderbird cheese zathura zathura-pdf-mupdf || { echo "[!] Failed to install optional software (1). Exiting."; exit 1; }
yay --noconfirm --needed -S zen-browser-bin proton-vpn-gtk-app localsend-bin tex-match || { echo "[!] Failed to install optional software (2). Exiting."; exit 1; }

systemctl --user enable syncthing
systemctl --user start syncthing
syncthing --browser-only

echo -e "\n[!] Installation successful!"
