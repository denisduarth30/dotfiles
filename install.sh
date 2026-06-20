#!/bin/bash
set -e

DOTFILES="$HOME/dotfiles"

echo "Rodando arquivo bootstrap.sh..."
bash "$DOTFILES/scripts/bootstrap.sh"

echo "Instalando pacotes via curl..."
bash "$DOTFILES/scripts/curl.sh"

echo "Instalando pacotes via python..."
bash "$DOTFILES/scripts/python.sh"

echo "Definindo configurações de área de trabalho..."
bash "$DOTFILES/scripts/appearance.sh"

echo "Configurando atalhos do Rofi..."
bash "$DOTFILES/scripts/autostart.sh"

echo "Finalizado. Faça logout e login novamente para aplicar as configurações."
