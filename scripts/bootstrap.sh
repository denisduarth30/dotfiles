#!/bin/bash
set -e

if [[ $EUID -eq 0 ]]; then
    echo "Não execute este script como root!"
    exit 1
fi

install_apt() {
    echo "Atualizando o sistema..."
    sudo apt update -y && sudo apt upgrade -y

    if ! command -v fastfetch &>/dev/null; then
        echo "Adicionando PPA do fastfetch..."
        sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
        sudo apt update -y
    fi

    if ! command -v papirus-folders &>/dev/null; then
        echo "Adicionando PPA do Papirus..."
        sudo add-apt-repository ppa:papirus/papirus
        sudo apt update -y
    fi

    PKGS=(
        alacritty
        gparted
        vlc
        fish
        build-essential
        python3
        python3-pip
        flatpak
        vulkan-tools
        fastfetch
        bat
        mangohud
        gamemode
        fonts-cascadia-code
        fonts-inconsolata
        eza
        ffmpeg
        fzf
        mpv
        mame-tools
        yt-dlp
        xournalpp
        micro
        stow
        papirus-folders
        papirus-icon-theme
    )

    for PKG in "${PKGS[@]}"; do
        echo "Instalando pacote $PKG..."
        sudo apt install -y "$PKG"
    done

    if ! command -v ani-cli &>/dev/null; then
        echo "Instalando ani-cli manualmente..."
        sudo curl -Lo /usr/local/bin/ani-cli \
            https://raw.githubusercontent.com/pystardust/ani-cli/master/ani-cli
        sudo chmod +x /usr/local/bin/ani-cli
    fi
}

set_swappiness() {
    echo "Definindo Swappiness em 10..."
    if ! grep -q "vm.swappiness" /etc/sysctl.conf; then
        echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
        sudo sysctl -p
    else
        echo "Swappiness já configurado, pulando."
    fi
}

install_dotfiles() {
    local DOTFILES_DIR="$HOME/dotfiles"

    echo "Instalando scripts..."
    sudo cp -i "$DOTFILES_DIR/utils/yt-dlp" "/usr/local/bin/yt-dlp"
    sudo chmod +x "/usr/local/bin/yt-dlp"

    echo "Removendo alvos existentes..."
    local targets=(
        "$HOME/.config/fish"
        "$HOME/.config/rofi"
        "$HOME/.config/zed"
        "$HOME/.config/fastfetch"
        "$HOME/.config/MangoHud"
        "$HOME/.config/alacritty"
        "$HOME/.fonts"
    )
    for target in "${targets[@]}"; do
        if [ -L "$target" ]; then
            rm "$target"
        elif [ -e "$target" ]; then
            mv "$target" "${target}.bak"
            echo "  [backup] $target → ${target}.bak"
        fi
    done

    echo "Linkando dotfiles..."
    cd "$DOTFILES_DIR" && stow fish rofi zed fastfetch mangohud alacrittyfonts

    echo "Atualizando cache de fontes..."
    fc-cache -fv
}

set_default_shell() {
    echo "Definindo Fish como shell padrão..."
    if command -v fish &>/dev/null; then
        chsh -s "$(which fish)"
        echo "Shell padrão definido com sucesso! reinicie a sessão para aplicar as mudanças."
    else
        echo "Fish não encontrado, algo deu errado!"
        exit 1
    fi
}

install_apt
set_swappiness
install_dotfiles
set_default_shell
