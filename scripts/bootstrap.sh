#!/bin/bash
set -e

if [[ $EUID -eq 0 ]]; then
    echo "Não execute este script como root!"
    exit 1
fi

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


install_arch() {
    if ! command -v paru &>/dev/null; then
        echo "paru não encontrado. Instalando..."
        sudo pacman -S --needed --noconfirm base-devel git
        git clone https://aur.archlinux.org/paru.git /tmp/paru
        cd /tmp/paru && makepkg -si --noconfirm
        cd - || exit
    fi

    echo "Atualizando o sistema..."
    sudo pacman -Syu --noconfirm

    PKGS=(
        alacritty
        gparted
        vlc
        fish
        base-devel
        python
        python-pip
        flatpak
        vulkan-tools
        fastfetch
        bat
        mangohud
        gamemode
        ttf-cascadia-code
        ttf-inconsolata
        eza
        ffmpeg
        fzf
        mpv
        mame
        yt-dlp
        xournalpp
        micro
        zoxide
    )

    echo "Instalando pacotes oficiais..."
    sudo pacman -S --needed --noconfirm "${PKGS[@]}"

    echo "Instalando pacotes do AUR..."
    paru -S --needed --noconfirm ani-cli
}

install_apt() {
    echo "Atualizando o sistema..."
    sudo apt update -y && sudo apt upgrade -y

    if ! command -v fastfetch &>/dev/null; then
        echo "Adicionando PPA do fastfetch..."
        sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
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
        zoxide
    )

    echo "Instalando pacotes..."
    sudo apt install -y "${PKGS[@]}"

    if ! command -v ani-cli &>/dev/null; then
        echo "Instalando ani-cli manualmente..."
        sudo curl -Lo /usr/local/bin/ani-cli \
            https://raw.githubusercontent.com/pystardust/ani-cli/master/ani-cli
        sudo chmod +x /usr/local/bin/ani-cli
    fi
}

install_dnf() {
    echo "Atualizando o sistema..."
    sudo dnf upgrade -y --refresh

    if ! rpm -q rpmfusion-free-release &>/dev/null; then
        echo "Habilitando RPM Fusion..."
        sudo dnf install -y \
            "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
            "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
    fi

    PKGS=(
        alacritty
        gparted
        vlc
        fish
        "@development-tools"
        python3
        python3-pip
        flatpak
        vulkan-tools
        fastfetch
        bat
        mangohud
        gamemode
        cascadia-code-fonts
        levien-inconsolata-fonts
        eza
        ffmpeg
        fzf
        mpv
        mame
        yt-dlp
        xournalpp
        micro
        zoxide
    )

    echo "Instalando pacotes..."
    sudo dnf install -y "${PKGS[@]}"

    if ! command -v ani-cli &>/dev/null; then
        echo "Instalando ani-cli manualmente..."
        sudo curl -Lo /usr/local/bin/ani-cli \
            https://raw.githubusercontent.com/pystardust/ani-cli/master/ani-cli
        sudo chmod +x /usr/local/bin/ani-cli
    fi
}

install_dnf_rhel() {
    echo "Atualizando o sistema..."
    sudo dnf upgrade -y

    if ! rpm -q epel-release &>/dev/null; then
        echo "Habilitando EPEL..."
        sudo dnf install -y epel-release
        sudo dnf config-manager --set-enabled crb
    fi

    if ! rpm -q rpmfusion-free-release &>/dev/null; then
        echo "Habilitando RPM Fusion..."
        sudo dnf install -y \
            "https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm" \
            "https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm"
    fi

    PKGS=(
        alacritty
        gparted
        fish
        vlc
        "@development-tools"
        python3
        python3-pip
        flatpak
        vulkan-tools
        bat
        fzf
        mpv
        ffmpeg
        yt-dlp
        micro
        zoxide
    )

    echo "Instalando pacotes disponíveis..."
    sudo dnf install -y "${PKGS[@]}"

    echo "Instalando pacotes sem repositório oficial no RHEL..."

    if ! command -v fastfetch &>/dev/null; then
        FASTFETCH_URL=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest \
            | grep "browser_download_url.*linux-amd64.rpm" | cut -d '"' -f 4)
        sudo dnf install -y "$FASTFETCH_URL"
    fi

    if ! command -v eza &>/dev/null; then
        EZA_URL=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest \
            | grep "browser_download_url.*x86_64-unknown-linux-musl.tar.gz" | cut -d '"' -f 4)
        curl -Lo /tmp/eza.tar.gz "$EZA_URL"
        tar -xzf /tmp/eza.tar.gz -C /tmp
        sudo mv /tmp/eza /usr/local/bin/eza
        sudo chmod +x /usr/local/bin/eza
    fi

    if ! command -v ani-cli &>/dev/null; then
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
    local DOTFILES_DIR
    DOTFILES_DIR="$HOME/dotfiles"

    local DOTFILES_CONFIG="$DOTFILES_DIR/.config"
    local HOME_CONFIG="$HOME/.config"

    echo "Instalando scripts..."
    sudo cp -i "$DOTFILES_DIR/utils/yt-dlp" "/usr/local/bin/yt-dlp"
    sudo chmod +x "/usr/local/bin/yt-dlp"

    echo "Linkando .config..."
    mkdir -p "$HOME_CONFIG"

    for dir in "$DOTFILES_CONFIG"/*/; do
        local name target

        name="$(basename "$dir")"
        target="$HOME_CONFIG/$name"

        if [ -L "$target" ] && [ "$(readlink "$target")" = "$dir" ]; then
            echo "  [skip] $name"
            continue
        fi

        if [ -d "$target" ] && [ ! -L "$target" ]; then
            echo "  [backup] $name → ${target}.bak"
            mv "$target" "${target}.bak"
        fi

        ln -sf "$dir" "$target"
        echo "  [ok] $name → $target"
    done

    echo "Linkando fonts..."
    ln -sf ~/dotfiles/.fonts ~/.fonts
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
detect_distro

case "$PKG_MANAGER" in
    arch)     install_arch     ;;
    apt)      install_apt      ;;
    dnf)      install_dnf      ;;
    dnf_rhel) install_dnf_rhel ;;
esac

set_swappiness
install_dotfiles
set_default_shell
