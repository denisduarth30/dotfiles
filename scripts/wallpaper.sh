#!/usr/bin/env bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WALLPAPER="$DOTFILES_DIR/assets/interstellar.png"

if [[ ! -f "$WALLPAPER" ]]; then
    echo "Wallpaper não encontrado: $WALLPAPER"
    exit 1
fi

gsettings set org.cinnamon.desktop.background picture-uri "file://$WALLPAPER"
gsettings set org.cinnamon.desktop.background picture-options 'centered'
