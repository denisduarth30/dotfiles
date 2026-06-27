# **Dotfiles — Denis**

Configuração pessoal para Linux Mint (Ubuntu-based).
  - OBS: Preferências e configurações personalizadas voltadas para o Linux Mint por conta do uso de configurações gráficas do sistema usando gsettings. Ver mais em `dotfiles/scripts/appearance.sh`.
  - Caso você queira personalizar as configurações do sistema, edite o arquivo `dotfiles/scripts/appearance.sh`. Use configurações específicas da distro que está usando (**Ubuntu** ou **Debian**) para personalizar o sistema.

## 1. Pré-requisito

`git` deve estar instalado:

    sudo apt update && sudo apt install git

## 2. Instalação

    git clone https://github.com/denisduarth/dotfiles.git
    cd dotfiles
    chmod +x ./install.sh
    ./install.sh

## 3. Aplicativos instalados pelo bootstrap

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
| rofi | Interface de busca e seleção |

> Veja a lista completa em `scripts/bootstrap.sh`

## Funcionalidades

### 🎵 Download de músicas do YouTube
Download de músicas e playlists em mp3 via `yt-dlp`. Possível utilizar o rofi para buscar e selecionar músicas. Ver mais em `dotfiles/.config/fish/functions/rofi/rofi-run.fish`. Funções: `dwd_mp3_audios`, `dwd_mp3_playlists`, `dwd_mp4_videos`.
 - `dotfiles/.config/fish/functions/dwd_mp3_audios.fish`
 - `dotfiles/.config/fish/functions/dwd_mp3_playlists.fish`
 - `dotfiles/.config/fish/functions/dwd_mp4_videos.fish`

### 🎮 Conversão de ISOs para CHD (PS1/PS2)
Converte ISOs para o formato CHD usando `mame-tools`.
Os jogos são salvos em `~/Games/ps1` ou `~/Games/ps2`.
> `dotfiles/.config/fish/functions/zip_to_chd.fish`

### 📒 Aliases
Atalhos para apt, limpeza de cache, processos e mais.
> `dotfiles/.config/fish/conf.d/aliases.fish`

### 📺 Animes via terminal
Assistir animes pelo terminal com `ani-cli`.
- Possível utilizar o rofi para buscar e selecionar animes. Ver mais em `dotfiles/.config/fish/functions/rofi/rofi-ani-cli.fish`
