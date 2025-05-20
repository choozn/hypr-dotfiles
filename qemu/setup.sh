# Copyright (C) 2025 choozn
# Installation script for virt-manager and qemu

sudo pacman --noconfirm --needed -S libvirt dnsmasq virt-manager qemu-full || { echo "[!] Failed to install virtualization software (1). Exiting."; exit 1; }
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
sudo usermod -G libvirt -a $(whoami)

# Only force connect when needed
# virt-manager --connect qemu:///system
