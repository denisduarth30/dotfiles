#!/bin/bash
set -e

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO_ID="${ID}"
        DISTRO_ID_LIKE="${ID_LIKE:-}"
    else
        echo "Não foi possível detectar a distro. /etc/os-release não encontrado."
        exit 1
    fi

    case "$DISTRO_ID" in
        arch|cachyos|endeavouros|manjaro|garuda)
            PKG_MANAGER="arch"
            ;;
        debian|ubuntu|linuxmint|pop)
            PKG_MANAGER="apt"
            ;;
        fedora)
            PKG_MANAGER="dnf"
            ;;
        rhel|almalinux|rocky|centos)
            PKG_MANAGER="dnf_rhel"
            ;;
        *)
            if echo "$DISTRO_ID_LIKE" | grep -q "arch"; then
                PKG_MANAGER="arch"
            elif echo "$DISTRO_ID_LIKE" | grep -q "debian\|ubuntu"; then
                PKG_MANAGER="apt"
            elif echo "$DISTRO_ID_LIKE" | grep -q "fedora\|rhel"; then
                PKG_MANAGER="dnf"
            else
                echo "Distro não suportada: $DISTRO_ID"
                exit 1
            fi
            ;;
    esac

    echo "Distro detectada: $PRETTY_NAME"
    echo "Gerenciador de pacotes: $PKG_MANAGER"
    echo ""
}

detect_distro

if ! command -v pip3 &>/dev/null; then
    echo "pip3 não encontrado. Instalando..."
    if [ "$PKG_MANAGER" = "arch" ]; then
        sudo pacman -S --needed --noconfirm python-pip
    elif [ "$PKG_MANAGER" = "apt" ]; then
        sudo apt install -y python3-pip
    elif [ "$PKG_MANAGER" = "dnf" ]; then
        sudo dnf install -y python3-pip
    elif [ "$PKG_MANAGER" = "dnf_rhel" ]; then
        sudo dnf install -y python3-pip
    fi
fi

echo "Instalando tldr..."
pip3 install tldr --break-system-packages

echo "Instalando yt-dlp..."
pip3 install -U yt-dlp --break-system-packages
