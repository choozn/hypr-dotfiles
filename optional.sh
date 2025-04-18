#!/bin/bash
# Copyright (C) 2025 choozn
# Installation script for optional software

# Remove autostart of this script
sed -i '/exec-once = alacritty --class "alacritty-float,alacritty-float" -e zsh -i -c "~\/.config\/hypr\/optional.sh; exec zsh"/d' "$HOME/.config/hypr/hyprland.conf"

# Remove flag file for first start
if [ -f "$HOME/.config/hypr/first.start" ]; then
    rm "$HOME/.config/hypr/first.start" || { echo "[!] Failed to remove flag file. Exiting."; exit 1; }
fi

cat << "EOF"
 _._     _,-'""`-._
(,-.`._,'(       |\`-/|
    `-.-' \ )-`( , o o)
          `-    \`_`"'-  Meow! Welcome (back), human!

EOF

echo "[!] There are still some packages missing to make your system functional."
echo "[!] This includes AUR packages and themes. It's recommended to install them."

read -p "[?] Should I install them for you? (y/n) " answer
answer=${answer:-y}
if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "[!] Alright, maybe next time. Take care!"
    exit 0
fi

echo -e "\n[!] To install the packages, I'll need you to give me sudo privileges."
echo -e "[!] No need to worry, Everything will be purrfectly handled.\n"

# Request sudo privileges
sudo -v || { echo "[!] Failed to gain sudo access. Exiting"; exit 1; }

# Install yay
# Reference: https://github.com/Jguer/yay
command -v yay >/dev/null 2>&1 || {
    git clone --depth=1 https://aur.archlinux.org/yay-bin.git || { echo "[!] Failed to clone yay repository. Exiting."; exit 1; }
    cd yay-bin
    makepkg -si --noconfirm || { echo "[!] Failed to install yay (1). Exiting."; exit 1; }
    cd ..
    rm -rf yay-bin || { echo "[!] Failed to install yay (2). Exiting."; exit 1; }
}

yay --noconfirm -Syu || { echo "[!] Failed to run system update with yay. Exiting."; exit 1; }

# Install topgrade
yay --noconfirm --needed -S topgrade-bin || { echo "[!] Failed to install topgrade. Exiting."; exit 1; }

# Install Catppuccin GTK Theme
yay --noconfirm --needed -S catppuccin-gtk-theme-mocha || { echo "[!] Failed to install catppuccin-gtk-theme. Exiting."; exit 1; }

# Remove old xsettingsd config
if [ -f "$HOME/.config/xsettingsd/xsettingsd.conf" ]; then
    rm "$HOME/.config/xsettingsd/xsettingsd.conf" || { echo "[!] Failed to remove old xsettingsd config. Exiting."; exit 1; }
fi

# Remove old .zshrc config
if [ -f "$HOME/.config/gtk-3.0/settings.ini" ]; then
    rm "$HOME/.config/gtk-3.0/settings.ini" || { echo "[!] Failed to remove old gtk-3 config. Exiting."; exit 1; }
fi

# Link gtk theme config files
mkdir -p "$HOME/.config/xsettingsd/" || { echo "[!] Failed to link xsettingsd config (1). Exiting."; exit 1; }
mkdir -p "$HOME/.config/gtk-3.0/" || { echo "[!] Failed to link gtk-3 config (1). Exiting."; exit 1; }
ln -s "$HOME/.config/hypr/gtk/xsettingsd.conf" "$HOME/.config/xsettingsd/xsettingsd.conf" || { echo "[!] Failed to link xsettingsd config (2). Exiting."; exit 1; }
ln -s "$HOME/.config/hypr/gtk/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini" || { echo "[!] Failed to link gtk-3 config (2). Exiting."; exit 1; }

# Apply theme
source "$HOME/.config/hypr/scripts/gtktheme"

# Install nwg-look and nwg-displays
yay --noconfirm --needed -S nwg-look nwg-displays || { echo "[!] Failed to install nwg-look. Exiting."; exit 1; }

# Install firmware software
sudo pacman --noconfirm --needed -S fwupd gnome-firmware || { echo "[!] Failed to install fwupd and gnome-firmware. Exiting."; exit 1; }

echo -e "\n[!] Installation successful!"

cat << "EOF"

 /\_/\
( ^w^ )  All done! Your setup is nice and cozy now! See you arround!
 > ^ <

EOF
