#!/bin/bash
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
    echo "Não execute este script como root!"
    exit 1
fi

log() {
    echo -e "\n==> $*"
}

migrate_shortcuts() {
    local SCRIPT="$HOME/.local/bin/migrar-atalhos-cinnamon"

    if [[ ! -x "$SCRIPT" ]]; then
        echo "Script de migração não encontrado em $SCRIPT, pulando."
        return
    fi

    if [[ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
        echo "Sem sessão gráfica ativa. Depois, rode 'migrar-atalhos-cinnamon' dentro do Cinnamon."
        return
    fi

    log "Simulando a migração dos atalhos do sxhkd para o Cinnamon..."
    "$SCRIPT" --simular

    local resposta=""
    read -r -p "Aplicar a migração? [s/N] " resposta || true
    if [[ "$resposta" =~ ^[sS]$ ]]; then
        log "Aplicando migração..."
        "$SCRIPT"
        pkill -x sxhkd 2>/dev/null || true
    else
        echo "Migração não aplicada. Você pode rodar 'migrar-atalhos-cinnamon' depois."
    fi
}

install_apt() {
    log "Atualizando o sistema..."
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y software-properties-common

    if ! command -v fastfetch &>/dev/null; then
        log "Adicionando PPA do fastfetch..."
        sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
    fi

    if ! command -v papirus-folders &>/dev/null; then
        log "Adicionando PPA do Papirus..."
        sudo add-apt-repository -y ppa:papirus/papirus
    fi

    sudo apt update

    local PKGS=(
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
        zram-tools
        sxhkd
        libglib2.0-bin
    )

    log "Instalando pacotes..."
    sudo apt install -y "${PKGS[@]}"

    log "Adicionando repositório Flathub (se ainda não existir)..."
    sudo flatpak remote-add --if-not-exists flathub \
        https://dl.flathub.org/repo/flathub.flatpakrepo

    if ! command -v ani-cli &>/dev/null; then
        log "Instalando ani-cli..."
        curl -fsSL -o /tmp/ani-cli \
            https://raw.githubusercontent.com/pystardust/ani-cli/master/ani-cli
        sudo install -m 755 /tmp/ani-cli /usr/local/bin/ani-cli
        rm -f /tmp/ani-cli
    fi
}

set_swappiness() {
    log "Definindo swappiness em 10..."
    sudo sed -i '/^vm\.swappiness/d' /etc/sysctl.conf
    echo "vm.swappiness=10" | sudo tee /etc/sysctl.d/99-swappiness.conf >/dev/null
    sudo sysctl --system >/dev/null
}

install_dotfiles() {
    local DOTFILES_DIR="$HOME/dotfiles"
    local STAMP
    STAMP="$(date +%Y%m%d-%H%M%S)"

    if [[ ! -d "$DOTFILES_DIR" ]]; then
        echo "Diretório $DOTFILES_DIR não encontrado!"
        exit 1
    fi

    log "Removendo links antigos e fazendo backup do que existir..."
    local targets=(
        "$HOME/.config/fish"
        "$HOME/.config/rofi"
        "$HOME/.config/zed"
        "$HOME/.config/fastfetch"
        "$HOME/.config/MangoHud"
        "$HOME/.config/alacritty"
        "$HOME/.fonts"
        "$HOME/.config/sxhkd"
    )
    for target in "${targets[@]}"; do
        if [[ -L "$target" ]]; then
            rm "$target"
        elif [[ -e "$target" ]]; then
            mv "$target" "${target}.bak-${STAMP}"
            echo "  [backup] $target → ${target}.bak-${STAMP}"
        fi
    done

    log "Linkando dotfiles com stow..."
    (
        cd "$DOTFILES_DIR"
        stow --restow fish rofi zed fastfetch mangohud alacritty fonts sxhkd
        stow --restow --no-folding bin
    )

    log "Atualizando cache de fontes..."
    fc-cache -f
}

set_default_shell() {
    local FISH_PATH
    FISH_PATH="$(command -v fish || true)"

    if [[ -z "$FISH_PATH" ]]; then
        echo "Fish não encontrado, algo deu errado!"
        exit 1
    fi

    if ! grep -qxF "$FISH_PATH" /etc/shells; then
        log "Registrando $FISH_PATH em /etc/shells..."
        echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
    fi

    local CURRENT_SHELL
    CURRENT_SHELL="$(getent passwd "$(id -un)" | cut -d: -f7)"

    if [[ "$CURRENT_SHELL" == "$FISH_PATH" ]]; then
        echo "Fish já é o shell padrão, pulando."
        return
    fi

    log "Definindo Fish como shell padrão..."
    chsh -s "$FISH_PATH"
    echo "Shell padrão definido! Reinicie a sessão para aplicar."
}

config_zram() {
    if dpkg -s zram-config &>/dev/null; then
        log "Removendo zram-config (conflita com zram-tools)..."
        sudo systemctl disable --now zram-config 2>/dev/null || true
        sudo apt purge -y zram-config
    fi

    log "Configurando ZRAM..."
    sudo tee /etc/default/zramswap >/dev/null <<'EOF'
ALGO=lz4
PERCENT=25
EOF

    sudo systemctl enable zramswap
    sudo systemctl restart zramswap

    echo "ZRAM configurado! Status:"
    zramctl || true
}

install_apt
set_swappiness
install_dotfiles
migrate_shortcuts
set_default_shell
config_zram

log "Tudo pronto! Faça logout e login para aplicar o Fish e as demais mudanças."
