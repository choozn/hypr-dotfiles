#!/bin/bash
# Copyright (C) 2025 choozn
# Installation script for optional software

# Remove autostart of this script
sed -i '/exec-once = $alacritty -f -e ~\/.config\/hypr\/optional.sh/d' "$HOME/.config/hypr/hyprland.conf"

echo "[!] Welcome (back) home!"
echo "[!] There are still some packages missing that would enrich your experience."
echo "[?] Should I install them for you?"

sudo -v || { echo "[!] Failed to gain sudo access. Exiting"; exit 1; }

# Install yay
# Reference: https://github.com/Jguer/yay
command -v yay >/dev/null 2>&1 || {
    git clone https://aur.archlinux.org/yay-bin.git || { echo "[!] Failed to clone yay repository. Exiting."; exit 1; }
    cd yay-bin
    makepkg -si --noconfirm || { echo "[!] Failed to install yay (1). Exiting."; exit 1; }
    cd ..
    rm -rf yay-bin || { echo "[!] Failed to install yay (2). Exiting."; exit 1; }
}

yay --noconfirm -Syu || { echo "[!] Failed to run system update with yay. Exiting."; exit 1; }

# Install firefox
sudo pacman --noconfirm --needed -S firefox || { echo "[!] Failed to install firefox. Exiting."; exit 1; }

# Install topgrade
yay --noconfirm --needed -S topgrade-bin || { echo "[!] Failed to install optional software (2). Exiting."; exit 1; }

# Install typescript and node tooling
sudo pacman --noconfirm --needed -S ts-node || { echo "[!] Failed to install optional software (1). Exiting."; exit 1; }
yay --noconfirm --needed -S nvm || { echo "[!] Failed to install optional software (2). Exiting."; exit 1; }

# Install optional other software
sudo pacman --noconfirm --needed -S gparted gimp libreoffice-still obsidian syncthing signal-desktop drawio-desktop vlc || { echo "[!] Failed to install optional software (1). Exiting."; exit 1; }
yay --noconfirm --needed -S ungoogled-chromium-bin syncthingtray-qt6 webcord-bin || { echo "[!] Failed to install optional software (2). Exiting."; exit 1; }

topgrade

echo "[!] Installation successful!"
