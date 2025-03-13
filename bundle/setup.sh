#!/bin/bash
# Copyright (C) 2025 choozn
# Installation script for optional software bundle

echo "[!] Started installation of the optional software bundle."

# Request sudo privileges
sudo -v || { echo "[!] Failed to gain sudo access."; exit 1; }
echo ""

# Install optional other software
sudo pacman --noconfirm --needed -S firefox filelight gimp libreoffice-still obsidian syncthing vlc || { echo "[!] Failed to install optional software. Exiting."; exit 1; }
echo ""

echo -e "[!] Installation successful!"
