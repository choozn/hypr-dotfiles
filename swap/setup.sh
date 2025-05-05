#!/bin/bash
# Copyright (C) 2025 choozn
# Setup script for Swapfile

# Request sudo privileges
sudo -v || { echo "[!] Failed to gain sudo access."; exit 1; }
echo ""

sudo mkswap -U clear --size 8G --file /swapfile
sudo swapon /swapfile
sudo bash -c 'echo "/swapfile    none    swap    sw    0   0" >> /etc/fstab'
