#!/bin/bash
# Copyright (C) 2025 choozn
# Installation script for my dotfiles
# It is recommended to install on a fresh Installation of Arch Linux

folder="hypr-dotfiles"
repository="https://github.com/choozn/$folder"

echo "[!] Starting installation of hypr-dotfiles by @choozn!"

# Request sudo privileges
sudo -v || { echo "Failed to gain sudo access."; exit 1; }
( while true; do sudo -v; sleep 60; done ) &

# Create installation folder
if [ ! -d "$DIRECTORY" ]; then
mkdir hyprinstall
fi
cd hyprinstall

# Install dependencies to install
sudo pacman --noconfirm -S --needed git base-devel

# Copy repository
git clone $repository

# Copy hyprland folder
cp ./$folder $HOME/.config/hypr
rm $HOME/.config/hypr/install.sh

# Install yay
# Reference: https://github.com/Jguer/yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

# Install Hyprland and other Hyprtools
# Reference: https://wiki.hyprland.org/Getting-Started/Installation/
sudo pacman --noconfirm -S hyprland hypridle hyprlock hyprpicker

# Install Waybar
# Reference: https://github.com/Alexays/Waybar/wiki/Installation
yay --noconfirm -S waybar

# Install SwayBG
# Reference: https://github.com/swaywm/swaybg
yay --noconfirm -S swaybg

# Install and configure zsh
# Reference: https://ohmyz.sh/#install
ZSH= sh install.sh
yay --noconfirm -S zsh 
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh plugins
# Reference: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
# Reference: https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
# Reference: https://github.com/zsh-users/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

# Configure zsh
cp ./.zshrc ~/.zshrc
source ~/.zshrc

# Install nvim
sudo pacman --noconfirm -S neovim

# Install alacritty
# Reference: https://github.com/alacritty/alacritty/blob/master/INSTALL.md
sudo pacman --noconfirm -S alacritty

# Configure alacritty
# Reference: https://alacritty.org/config-alacritty.html
rm -rf $HOME/.config/alacritty
ln -s $HOME/.config/hypr/alacritty $HOME/.config/alacritty

# Install other dependencies
yay --noconfirm -S htop powertop fzf fd ffmpeg mpc mpd lxappearance networkmanager nvm ts-node perf pulseaudio thunar thunar-archive-plugin tmux viewnior wireguard-tools xarchiver zip unzip unrar 7zip sl openvpn catppuccin-gtk-theme-mocha

# Install optional software
echo "[?] Install optional software?"
yay -S librewolf chromium tt-bin gparted btop gimp libreoffice obsidian syncthing syncthingtray-qt6 webcord signal-desktop drawio-desktop vlc

# Cleanup
cd ..
rm -rf hyprinstall

echo "[!] Installation successful!"
