# Dotfiles — Denis

Configuração pessoal para Linux (Debian/Ubuntu-based).

## 1. Pré-requisito

**git** deve estar instalado:

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

## 4. Dependências e utilização do `rofi-search.fish` e `rofi-theme.fish`
As dependências para o melhor uso do `rofi-search.fish` e `rofi-theme.fish` são:
  - Fontes: CommitMono Nerd Font (necessária para ícones e utilizada nos temas em `.config/rofi/themes/dark-theme.rasi` e `light-theme.rasi`)
  - Conforme surgir a necessidade de aplicar a busca para novos sites, editar o arquivo `rofi-search.fish` nas primeiras linhas.
    - O próprio arquivo `rofi-search.fish` já lida com a busca em guias anônimas
    - Necessário adicionar novos nomes, ícones, URLs e bangs nas variáveis `NAMES`, `ICONS`, `URLS` e `BANGS` no arquivo `rofi-search.fish`
    - Alguns já prontos são:
      - Google
      - DuckDuckGo
      - Youtube
      - Wikipedia
      - ...

      ```
        set NAMES \
          "Google" "YouTube" "X" "Google Images" "DuckDuckGo" \
          "GitHub" "GitLab" "Google Translate" "Wikipedia" \
          "Facebook Marketplace"

        set ICONS "" "" "" "󰋩" "󰇥" "" "" "󰊿" "󰖬" ""

        set URLS \
            "https://www.google.com/search?q=" \
            "https://www.youtube.com/results?search_query=" \
            "https://twitter.com/search?q=" \
            "https://www.google.com/search?hl=en&tbm=isch&q=" \
            "https://duckduckgo.com/?q=" \
            "https://github.com/search?q=" \
            "https://gitlab.com/search?search=" \
            "https://translate.google.com/?sl=auto&tl=pt&text=" \
            "https://pt.wikipedia.org/w/index.php?search=" \
            "https://www.facebook.com/marketplace/108568625834990/search/?query="

        set BANGS "!g" "!yt" "!x" "!img" "!ddg" "!gh" "!gl" "!tr" "!wp" "!fb"
      ```

> Todas sobre a configuração do rofi, olhar em `dotfiles/rofi/.config/rofi` e `dotfiles/fish/.config/fish/functions/rofi-search.fish e rofi-theme.fish`
