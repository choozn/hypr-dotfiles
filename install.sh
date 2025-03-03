#!/bin/bash
# Copyright (C) 2025 choozn
# Installation script for my dotfiles
# It is recommended to install on a fresh Installation of Arch Linux

folder="hypr-dotfiles"
repository="https://github.com/choozn/$folder"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (using sudo)."
   exit 1
fi

echo "[!] Starting installation of hypr-dotfiles by @choozn!"

# Request sudo privileges
sudo -v || { echo "Failed to gain sudo access."; exit 1; }

# Check permissions
if [ ! -w "$HOME/.config" ]; then
    echo "[!] You do not have write permissions for $HOME/.config. Please fix permissions and retry."
    exit 1
fi

# Backup previous configs
backupfolder="hypr_backup_$(date +'%Y-%m-%d_%H-%M-%S')"
backuppath="$HOME/.config/$backupfolder"
mkdir -p $backuppath

# Backup .zshrc
if [ -f "$HOME/.zshrc" ]; then
  cp "$HOME/.zshrc" "$backuppath/.zshrc"
fi

# Backup .config/hypr
if [ -d "$HOME/.config/hypr" ]; then
  cp -r "$HOME/.config/hypr/" "$backuppath/hypr/"
fi

# Backup .config/alacritty
if [ -d "$HOME/.config/alacritty" ]; then
  cp -r "$HOME/.config/alacritty/" "$backuppath/alacritty/"
fi

# Clear installation folder
if [ -d "hyprinstall" ]; then
    rm -rf "hyprinstall"
fi

# Create installation folder
if [ ! -d "$DIRECTORY" ]; then
mkdir "hyprinstall"
fi

# Move into installation directory
cd "hyprinstall"

# Install dependencies to install
sudo pacman --noconfirm -S --needed git base-devel || { echo "Failed to install git or base-devel. Exiting."; exit 1; }

# Copy repository
git clone $repository || { echo "Failed to clone dotfiles. Exiting."; exit 1; } 

# Copy hyprland folder
cp -rf "./$folder" "$HOME/.config/hypr"
# rm $HOME/.config/hypr/install.sh

# Install yay
# Reference: https://github.com/Jguer/yay
command -v yay >/dev/null 2>&1 || {
    git clone https://aur.archlinux.org/yay.git || { echo "Failed to clone yay repository. Exiting."; exit 1; }
    cd yay
    makepkg -si || { echo "Failed to install yay. Exiting."; exit 1; }
    cd ..
    rm -rf yay
}

# Install Hyprland and other Hyprtools
# Reference: https://wiki.hyprland.org/Getting-Started/Installation/
sudo pacman --noconfirm --needed -S hyprland hypridle hyprlock hyprpicker || { echo "Failed to install Hyprland packages. Exiting."; exit 1; }

# Install Waybar
# Reference: https://github.com/Alexays/Waybar/wiki/Installation
yay --noconfirm --needed -S waybar || { echo "Failed to install Waybar. Exiting."; exit 1; }

# Install SwayBG
# Reference: https://github.com/swaywm/swaybg
yay --noconfirm --needed -S swaybg || { echo "Failed to install SwayBG. Exiting."; exit 1; }

# Install and configure OhMyZsh
# Reference: https://ohmyz.sh/#install
yay --noconfirm --needed -S zsh 
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || { echo "Failed to install OhMyZsh. Exiting."; exit 1; }
fi

# Install zsh plugins
# Reference: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
# Reference: https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
# Reference: https://github.com/zsh-users/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

# Copy .zshrc config
cp -f "./$folder/.zshrc" "$HOME/.zshrc"

# Install nvim
sudo pacman --noconfirm --needed -S neovim || { echo "Failed to install neovim. Exiting."; exit 1; }

# Install alacritty
# Reference: https://github.com/alacritty/alacritty/blob/master/INSTALL.md
sudo pacman --noconfirm --needed -S alacritty || { echo "Failed to install alacritty. Exiting."; exit 1; }

# Configure alacritty
# Reference: https://alacritty.org/config-alacritty.html
if [ -d "$HOME/.config/hypr/alacritty" ]; then
    rm -rf "$HOME/.config/alacritty"
fi
if [ ! -L "$HOME/.config/alacritty" ]; then
    ln -s "$HOME/.config/hypr/alacritty" "$HOME/.config/alacritty"
fi

# Install other dependencies
yay --noconfirm --needed -S htop powertop fzf fd ffmpeg mpc mpd lxappearance networkmanager nvm ts-node perf pulseaudio thunar thunar-archive-plugin tmux viewnior wireguard-tools xarchiver zip unzip unrar 7zip sl openvpn catppuccin-gtk-theme-mocha || { echo "Failed to install dependency packages. Exiting."; exit 1; }

# Install optional software
echo "[?] Install optional software?"
read -p "Do you want to continue? (y/N): " install_optional
if [[ "$install_optional" =~ ^[Yy]$ ]]; then
    yay --needed -S librewolf chromium tt-bin gparted btop gimp libreoffice obsidian syncthing syncthingtray-qt6 webcord signal-desktop drawio-desktop vlc
fi

# Cleanup
cd ..
if [ -d "hyprinstall" ]; then
    rm -rf "hyprinstall"
fi

# Complete Installation
echo "[!] Installation successful!"
