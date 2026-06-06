# Dotfiles — Denis

Configuração pessoal para Linux (Debian/Ubuntu-based).

## Pré-requisito

**git** deve estar instalado:

    sudo apt update && sudo apt install git

## Instalação

    git clone https://github.com/denisduarth/dotfiles.git
    cd dotfiles
    chmod +x ./install.sh
    ./install.sh

## Aplicativos instalados pelo bootstrap

| App | Funcionalidade |
|---|---|
| fish | Shell padrão |
| alacritty | Terminal |
| fastfetch | Info do sistema |
| bat | cat melhorado |
| eza | ls melhorado |
| fzf | Busca fuzzy |
| mpv | Player de vídeo |
| ffmpeg | Conversão de mídia |
| yt-dlp | Download do YouTube |
| ani-cli | Animes no terminal |
| mangohud | Overlay de performance |
| gamemode | Otimização para jogos |
| mame-tools | Conversão de ISOs (CHD) |
| micro | Editor de texto |
| vlc, gparted, xournalpp, flatpak, vulkan-tools, build-essential, python3 | Utilitários gerais |
| zed | Editor de código |

> Veja a lista completa em `scripts/bootstrap.sh`

## Funcionalidades

### 🎵 Download de músicas do YouTube
Download de músicas e playlists em mp3 via `yt-dlp`.
> `dotfiles/.config/fish/functions/dwd_mp3_audio.fish`

### 🎮 Conversão de ISOs para CHD (PS1/PS2)
Converte ISOs para o formato CHD usando `mame-tools`.
Os jogos são salvos em `~/Games/ps1` ou `~/Games/ps2`.
> `dotfiles/.config/fish/functions/zip_to_chd.fish`

### 📒 Aliases
Atalhos para apt, limpeza de cache, processos e mais.
> `dotfiles/.config/fish/conf.d/aliases.fish`

### 📺 Animes via terminal
Assistir animes pelo terminal com `ani-cli`.
