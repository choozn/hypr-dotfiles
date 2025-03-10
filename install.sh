#!/bin/bash
# Copyright (C) 2025 choozn
# Installation script for my dotfiles
# It is recommended to install on a fresh installation of Arch Linux
#
# To install in one line, run the following command:
# curl -Ls hypr.choozn.dev | bash

folder="hypr-dotfiles"
repository="https://github.com/choozn/$folder"

# Check if the script is run as root
if [[ $EUID -eq 0 ]]; then
   echo "[!] This script should NOT be run as root (or using sudo)."
   echo "[!] Please run this script only as the user for whom you want to install the dotfiles."
   exit 1
fi

# Welcome message
cat << "EOF"
 /\_/\  
( o.o )  Meow! I'm whisker and I'll help you to make this place feel like home!.
 > ^ <          Let's get those dotfiles and dependencies installed!

EOF

echo "[!] To install the dotfiles and other dependencies, I'll need you to give me sudo privileges."
echo "[!] Don't worry, I’m a well-behaved kitty! No messes, just magic."

# Request sudo privileges
sudo -v || { echo "[!] Failed to gain sudo access."; exit 1; }

# Create .config directory
if [ ! -d "$HOME/.config" ]; then
    mkdir "$HOME/.config" || { echo "[!] Failed to create .config directory. Exiting."; exit 1; }
fi

# Check permissions
if [ ! -w "$HOME/.config" ]; then
    echo "[!] You do not have write permissions for $HOME/.config. Please fix permissions and retry."
    exit 1
fi

# Backup previous configs
backup_folder="hypr_backup_$(date +'%Y-%m-%d_%H-%M-%S')"
backup_path="$HOME/.config/$backup_folder"
if [[ (-f "$HOME/.zshrc" || -d "$HOME/.config/hypr" || -d "$HOME/.config/alacritty") && ! -d "$backup_path" ]]; then
    mkdir -p $backup_path
fi

# Backup .zshrc
if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$backup_path/.zshrc" || { echo "[!] Failed to backup .zshrc config. Exiting."; exit 1; }
fi

# Backup .config/hypr
if [ -d "$HOME/.config/hypr" ]; then
    cp -r "$HOME/.config/hypr/" "$backup_path/hypr/" || { echo "[!] Failed to backup hyprland config files. Exiting."; exit 1; }
fi

# Backup .config/alacritty
if [ -d "$HOME/.config/alacritty" ]; then
    cp -r "$HOME/.config/alacritty/" "$backup_path/alacritty/" || { echo "[!] Failed to backup alacritty config files. Exiting."; exit 1; }
fi

echo "[!] The backup of previous config files has finished."

# Update pacman database and do a system update
sudo pacman --noconfirm -Syyu || { echo "[!] Failed to run system update with pacman. Exiting."; exit 1; }

# Install dependencies to install
sudo pacman --noconfirm -S --needed git base-devel || { echo "[!] Failed to install git or base-devel. Exiting."; exit 1; }

# Clear installation folder
if [ -d "hyprinstall" ]; then
    rm -rf "hyprinstall" || { echo "[!] Failed to delete already existing installation directory. Exiting."; exit 1; }
fi

# Create installation folder
if [ ! -d "hyprinstall" ]; then
    mkdir "hyprinstall" || { echo "[!] Failed to create installation directory. Exiting."; exit 1; }
fi

# Move into installation directory
cd "hyprinstall"

# Copy repository
git clone $repository || { echo "[!] Failed to clone dotfiles. Exiting."; exit 1; } 

# Create .config/hypr directory if its missing
if [ ! -d "$HOME/.config/hypr" ]; then
    mkdir "$HOME/.config/hypr" || { echo "[!] Failed to create .config/hypr directory. Exiting."; exit 1; }
fi

# Copy hyprland folder
find "./$folder" -maxdepth 1 -mindepth 1 -print0 | xargs -0 cp -rf -t "$HOME/.config/hypr/" || { echo "[!] Failed to copy Hyprland configuration. Exiting."; exit 1; }
sudo chmod +x $HOME/.config/hypr/optional.sh

# Cleanup installation directory
cd ..
if [ -d "hyprinstall" ]; then
    rm -rf "hyprinstall" || { echo "[!] Failed to delete installation directory. Exiting."; exit 1; }
fi

# Install Hyprland and other Hyprtools
# Reference: https://wiki.hyprland.org/Getting-Started/Installation/
# Reference: https://github.com/Alexays/Waybar/wiki/Installation
# Reference: https://github.com/swaywm/swaybg
sudo pacman --noconfirm --needed -S hyprland hypridle hyprlock hyprpicker waybar swaybg || { echo "[!] Failed to install Hyprland packages. Exiting."; exit 1; }

# Install Fonts
sudo pacman --noconfirm --needed -S ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-iosevka-nerd || { echo "[!] Failed to install Fonts. Exiting."; exit 1; }

# Install and configure OhMyZsh
# Reference: https://ohmyz.sh/#install
sudo pacman --noconfirm --needed -S zsh || { echo "[!] Failed to install zsh. Exiting."; exit 1; }
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || { echo "[!] Failed to install OhMyZsh. Exiting."; exit 1; }
fi

# Install zsh plugins
# Reference: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
# Reference: https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
# Reference: https://github.com/zsh-users/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

# Remove old .zshrc config
if [ -f "$HOME/.zshrc" ]; then
    rm "$HOME/.zshrc" || { echo "[!] Failed to remove old .zshrc config. Exiting."; exit 1; }
fi

# Remove old zsh theme
if [ -f "$HOME/.oh-my-zsh/custom/themes/choozn.zsh-theme" ]; then
    rm "$HOME/.oh-my-zsh/custom/themes/choozn.zsh-theme" || { echo "[!] Failed to remove old zsh theme. Exiting."; exit 1; }
fi

# Link new .zshrc and theme
ln -s "$HOME/.config/hypr/zsh/.zshrc" "$HOME/.zshrc" || { echo "[!] Failed to link zsh config. Exiting."; exit 1; }
ln -s "$HOME/.config/hypr/zsh/choozn.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/choozn.zsh-theme" || { echo "[!] Failed to link zsh config. Exiting."; exit 1; }

# Install nvim
sudo pacman --noconfirm --needed -S neovim || { echo "[!] Failed to install neovim. Exiting."; exit 1; }

# Install alacritty
# Reference: https://github.com/alacritty/alacritty/blob/master/INSTALL.md
sudo pacman --noconfirm --needed -S alacritty || { echo "[!] Failed to install alacritty. Exiting."; exit 1; }

# Configure alacritty
# Reference: https://alacritty.org/config-alacritty.html

# Remove alacritty config
if [ -d "$HOME/.config/hypr/alacritty" ]; then
    rm -rf "$HOME/.config/alacritty" || { echo "[!] Failed to clear alacritty folder. Exiting."; exit 1; }
fi

# Insert link to new alacritty config
if [ ! -L "$HOME/.config/alacritty" ]; then
    ln -s "$HOME/.config/hypr/alacritty" "$HOME/.config/alacritty" || { echo "[!] Failed to link alacritty config. Exiting."; exit 1; }
fi

# Install other dependencies
sudo pacman --noconfirm --needed -S man-db xclip wl-clipboard htop powertop fzf fd ffmpeg mpc mpd networkmanager bluez bluetui pulseaudio thunar thunar-archive-plugin tmux viewnior wireguard-tools xarchiver zip unzip unrar 7zip openvpn ranger || { echo "[!] Failed to install dependency packages. Exiting."; exit 1; }

# Activate NetworkManager and Bluetooth
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service

# TODO: Install gtk theme => catppuccin-gtk-theme-mocha 

# Complete Installation
echo "[!] Installation successful!"

# Start Hyprland
if [[ "$XDG_CURRENT_DESKTOP" != "Hyprland" ]]; then
    echo -e 'exec-once = $alacritty -f -e ~/.config/hypr/optional.sh' >> "$HOME/.config/hypr/hyprland.conf"
    Hyprland &
else
    source "$HOME/.config/hypr/optional.sh"
fi
