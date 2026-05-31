#!/bin/bash
set -e

DOTFILES="$HOME/dotfiles"

echo "Rodando arquivo bootstrap.sh..."
bash "$DOTFILES/scripts/bootstrap.sh"

echo "Instalando pacotes via curl..."
bash "$DOTFILES/scripts/curl.sh"

echo "Finalizado."
