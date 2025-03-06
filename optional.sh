#!/bin/bash
# Copyright (C) 2025 choozn
# Installation script for optional software

echo "[?] Should optional software like a webbrowser be installed?"
sudo -v || { echo "[!] Failed to gain sudo access. Exiting"; exit 1; }

# Install firefox
sudo pacman --noconfirm --needed -S firefox || { echo "[!] Failed to install firefox. Exiting."; exit 1; }

# Install optional other software
sudo pacman --noconfirm --needed -S gparted gimp libreoffice-still obsidian syncthing signal-desktop drawio-desktop vlc || { echo "[!] Failed to install optional software (1). Exiting."; exit 1; }
yay --noconfirm --needed -S ungoogled-chromium-bin syncthingtray-qt6 webcord-bin || { echo "[!] Failed to install optional software (2). Exiting."; exit 1; }

echo "[!] Installation successful!"
