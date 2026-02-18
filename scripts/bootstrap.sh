#!/bin/bash
set -e

if [[ $EUID -eq 0 ]]; then
  echo "Não execute este script como root!"
  exit 1
fi

echo "Primeira atualização do sistema..."
sudo apt update && sudo apt upgrade -y

echo "Adicionando PPA fastfetch..."
sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch

echo "Segundo update para os pacotes PPA"
sudo apt update

APT_PROGRAMS=(
  git
  gparted
  vlc
  build-essential
  python3
  python3-pip
  flatpak
  vulkan-tools
  fastfetch
  zsh
  bat
  mangohud
  gamemode
  fonts-cascadia-code
  fonts-firacode
  fonts-inconsolata
  zram-tools
  eza
)

echo "Instalando pacotes APT..."
sudo apt install -y "${APT_PROGRAMS[@]}"

echo "Definindo Swappiness em 10..."
if ! grep -q "vm.swappiness" /etc/sysctl.conf; then
  echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
  sudo sysctl -p
fi

backup_file() {
  if [ -f "$1" ]; then
      mv "$1" "$1.bak.$(date +%s)"
  fi
}

echo "Instalando dotfiles do Zsh..."

backup_file "$HOME/.zshrc"
backup_file "$HOME/.zsh_aliases"
backup_file "$HOME/.zsh_functions"

cp dotfiles/zsh/.zshrc "$HOME/.zshrc"
cp dotfiles/zsh/.zsh_aliases "$HOME/.zsh_aliases"
cp dotfiles/zsh/.zsh_functions "$HOME/.zsh_functions"

echo "Definindo Zsh como shell padrão..."
if command -v zsh >/dev/null; then
  chsh -s "$(which zsh)"
else
  echo "Zsh não encontrado!"
fi

echo "Configuração aplicada. Abra um novo terminal ou execute: source ~/.zshrc"
echo "Setup finalizado!"
echo "Reinicie a sessão ou abra um novo terminal para aplicar o Zsh e os aliases."
