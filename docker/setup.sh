# Copyright (C) 2025 choozn
# Installation script for docker

sudo pacman --noconfirm --needed -S docker docker-compose || { echo "[!] Failed to install docker (1). Exiting."; exit 1; }
sudo usermod -G docker -a $(whoami)
sudo systemctl enable docker
sudo systemctl start docker

echo "Please reboot for changes to take effect."
