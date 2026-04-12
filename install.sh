#!/bin/bash
set -e

DOTFILES="$HOME/dotfiles"

echo "Criando links simbólicos..."

ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/zsh/.zsh_aliases" "$HOME/.zsh_aliases"

echo "Rodando arquivo bootstrap.sh..."
bash "$DOTFILES/scripts/bootstrap.sh"

echo "Clonando repositórios de plugins para Oh My Zsh..."
bash "$DOTFILES/scripts/oh_my_zsh_plugins.sh"

echo "Instalando pacotes via curl..."
bash "$DOTFILES/scripts/curl.sh"

echo "Finalizado."
