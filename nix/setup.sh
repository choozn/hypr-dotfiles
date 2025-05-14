# Copyright (C) 2025 choozn
# Multiuser clean installation script for nix and nix-shell
# Reference: https://nix.dev/manual/nix/2.18/installation/uninstall
# Reference: https://nixos.org/download/

# Remove Single User installation
sudo rm -rf /nix

# Remove the Nix daemon service
sudo systemctl stop nix-daemon.service
sudo systemctl disable nix-daemon.socket nix-daemon.service
sudo systemctl daemon-reload

# Remove Nix files
sudo rm -rf /etc/nix /etc/profile.d/nix.sh /etc/tmpfiles.d/nix-daemon.conf /nix ~root/.nix-channels ~root/.nix-defexpr ~root/.nix-profile

# Remove nixbld users and nixbld group from prior installs
for i in $(seq -w 1 32); do
  sudo userdel nixbld$i
done
sudo groupdel nixbld

# Resolve network requests for nix on arch
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# Install nix
sh <(curl -L https://nixos.org/nix/install) --daemon
