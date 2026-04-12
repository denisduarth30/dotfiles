#!/bin/bash
set -e

if [[ $EUID -eq 0 ]]; then
  echo "Não execute este script como root!"
  exit 1
fi

echo "Primeira atualização do sistema..."
sudo apt update -y && sudo apt upgrade -y

echo "Adicionando PPA fastfetch..."
sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch

echo "Segundo update para os pacotes PPA"
sudo apt update -y

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
  fonts-inconsolata
  eza
  ani-cli
  ffmpeg
  fzf
  mpv
  mame-tools
  yt-dlp
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

mkdir -i ~/.scripts

echo "Copiando arquivos para seus locais específicos..."
cp -i dotfiles/zsh/.zshrc "$HOME/.zshrc"
cp -i dotfiles/zsh/.zsh_aliases "$HOME/.zsh_aliases"
cp -i dotfiles/zsh/.zsh_functions "$HOME/.zsh_functions"
cp -i dotfiles/scripts/zip2chd.sh "$HOME/.scripts/zip2chd.sh"
sudo cp -i dotfiles/utils/yt-dlp "/usr/local/bin/yt-dlp"

sudo chmod +x "$HOME/.scripts/zip2chd.sh"

echo "Definindo Zsh como shell padrão..."
if command -v zsh >/dev/null; then
  chsh -s "$(which zsh)"
else
  echo "Zsh não encontrado!"
fi

echo "Configuração aplicada.