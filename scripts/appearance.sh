#!/usr/bin/env bash

DOTFILES_DIR="$HOME/dotfiles"
WALLPAPER="$DOTFILES_DIR/assets/interstellar.png"

if [[ ! -f "$WALLPAPER" ]]; then
    echo "Wallpaper não encontrado: $WALLPAPER"
    exit 1
fi

echo "Definindo wallpaper para: $WALLPAPER"
gsettings set org.cinnamon.desktop.background picture-uri "file://$WALLPAPER"
gsettings set org.cinnamon.desktop.background picture-options 'scaled'

echo "Definindo tema para mouse"
gsettings set org.cinnamon.desktop.interface cursor-theme 'Adwaita'
gsettings set org.cinnamon.desktop.interface cursor-size 16

echo "Definindo tema para Mint-Y-Dark-Grey"
gsettings set org.cinnamon.desktop.interface gtk-theme 'Mint-Y-Dark-Grey'

echo "Definindo tema para tema do Cinnamon"
gsettings set org.cinnamon.theme name 'Mint-Y-Dark-Grey'

echo "Definindo tema para Papirus"
gsettings set org.cinnamon.desktop.interface icon-theme 'Papirus'

if command -v papirus-folders &>/dev/null; then
    papirus-folders -C grey --theme Papirus
else
    echo "papirus-folders não encontrado, pulando..."
fi

EXTENSIONS_DIR="$HOME/.local/share/cinnamon/extensions"
TRANSPARENT_PANELS="transparent-panels@germanfr"

echo "Instalando extensões do Cinnamon"
if [[ ! -d "$EXTENSIONS_DIR/$TRANSPARENT_PANELS" ]]; then
    git clone https://github.com/germanfr/cinnamon-transparent-panels.git /tmp/cinnamon-transparent-panels
    (cd /tmp/cinnamon-transparent-panels && ./utils.sh install)
    rm -rf /tmp/cinnamon-transparent-panels
else
    echo "Transparent Panels já instalado, pulando..."
fi

echo "Ativando extensões do Cinnamon"
gsettings set org.cinnamon enabled-extensions "['$TRANSPARENT_PANELS']"
