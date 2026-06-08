#!/bin/bash
set -e

if ! command -v pip3 &>/dev/null; then
    echo "pip3 não encontrado. Instalando..."
    sudo apt install -y python3-pip
fi

echo "Instalando tldr..."
pip3 install tldr --break-system-packages

echo "Instalando yt-dlp..."
pip3 install -U yt-dlp --break-system-packages
