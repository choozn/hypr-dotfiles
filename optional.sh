#!/bin/bash
# Copyright (C) 2025 choozn
# Installation script for optional software

# Remove autostart of this script
sed -i '/exec-once = alacritty --class "alacritty-float,alacritty-float" -e zsh -i -c "~\/.config\/hypr\/optional.sh; exec zsh"/d' "$HOME/.config/hypr/hyprland.conf"

cat << "EOF"
 _._     _,-'""`-._
(,-.`._,'(       |\`-/|
    `-.-' \ )-`( , o o)
          `-    \`_`"'-  Meow! Welcome (back), human!
         
EOF

echo "[!] There are still some packages missing that would enrich your experience."

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
    git clone https://aur.archlinux.org/yay-bin.git || { echo "[!] Failed to clone yay repository. Exiting."; exit 1; }
    cd yay-bin
    makepkg -si --noconfirm || { echo "[!] Failed to install yay (1). Exiting."; exit 1; }
    cd ..
    rm -rf yay-bin || { echo "[!] Failed to install yay (2). Exiting."; exit 1; }
}

yay --noconfirm -Syu || { echo "[!] Failed to run system update with yay. Exiting."; exit 1; }

# Install topgrade
yay --noconfirm --needed -S topgrade-bin || { echo "[!] Failed to install topgrade. Exiting."; exit 1; }
echo -e 'exec-once = alacritty --class "alacritty-float,alacritty-float" -e zsh -i -c "topgrade; exec zsh"' >> "$HOME/.config/hypr/hyprland.conf"

# Install firefox
sudo pacman --noconfirm --needed -S firefox || { echo "[!] Failed to install firefox. Exiting."; exit 1; }

# Install optional other software
sudo pacman --noconfirm --needed -S gparted gimp libreoffice-still obsidian syncthing vlc || { echo "[!] Failed to install optional software (1). Exiting."; exit 1; }
yay --noconfirm --needed -S webcord-bin || { echo "[!] Failed to install optional software (2). Exiting."; exit 1; }

echo -e "[!] Installation successful!\n"

cat << "EOF"
 /\_/\  
( ^w^ )  All done! Your setup is nice and cozy now! See you arround!
 > ^ <  
EOF
