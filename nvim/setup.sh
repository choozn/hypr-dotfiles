#!/bin/bash
# Copyright (C) 2025 choozn
# Installation script for astrovim
# Reference: https://docs.astronvim.com/#-installation

# Make a backup of current nvim config 
mv ~/.config/nvim ~/.config/nvim.bak

# Clean neovim folders
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak

# Clone the repository
git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim

# Remove template's git connection to set up your own later
rm -rf ~/.config/nvim/.git
nvim
