#!/bin/bash
# Copyright (C) 2025 choozn
# Installation script for ly-dm

echo "[!] Started installation of the ly-Display-Manager."

# Request sudo privileges
sudo -v || { echo "[!] Failed to gain sudo access."; exit 1; }
echo ""

# Install ly
sudo pacman --noconfirm --needed -S ly || { echo "[!] Failed to install ly. Exiting."; exit 1; }
echo ""

# Remove old ly config
if [ -f "/etc/ly/config.ini" ]; then
  sudo rm "/etc/ly/config.ini" || { echo "[!] Failed to remove old ly config."; exit 1; }
fi

# Link ly config
sudo ln -s "$HOME/.config/hypr/ly/config.ini" "/etc/ly/config.ini" || { echo "[!] Failed to link ly config. Exiting."; exit 1; }

# Copy default session
sudo cp "$HOME/.config/hypr/ly/save.ini" "/etc/ly/save.ini"  || { echo "[!] Failed to copy default ly session. Exiting."; exit 1; }

# Activate ly servie
sudo systemctl enable ly.service
sudo systemctl disable getty@tty2.service

echo -e "[!] Installation of ly-Display-Manager successful!"
