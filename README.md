# Configuração para Linux do dotfile

## Aplicativos pré instalados obrigatórios*

* **git**
###
    sudo apt update && sudo apt install git

## 1. Aplicativos instalados pelo script.

* alacritty (terminal)
* gparted
* vlc
* fish (shell)
* build-essential
* python3
* python3-pip
* flatpak
* vulkan-tools
* fastfetch
* fish
* bat (batcat)
* gamemode
* mangohud
* eza
* ani-cli
* ffmpeg
* fzf
* mpv
* mame-tools
* yt-dlp
* xournalpp
* micro (editor de texto)

#### \*Veja mais em dotfiles/scripts/bootstrap.sh

## 2. Funções criadas pelo script.

### 2.1. Músicas e playlists do Youtube 🎵 

- Download de músicas do youtube em mp3
- Download de playlists do youtube em mp3
  - Ambos dependem do arquivo **yt-dlp** em **/utils/yt-dlp**
  - **Fonte original:** **https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#installation**

### 2.2. ISOS de PS1 e PS2 🎮️

- Conversão de ISOS de PS1 e PS2 para o formato CHD
  - Depende do plugin **mame-tools** para fazer as conversões
  - **OBS:** Após a cópia do plugin ser feita, os jogos vão todos para a pasta **/home/$USER/Games/[ps1 ou ps2]** (dependendo da escolha de conversão do jogo)

  #### **\*Veja mais em dotfiles/.config/fish/functions/zip_to_chd.fish**

### 2.3. Aliases 📒

- Criação de aliases para facilitar o uso do S.O, principalmente para:
  - Instalação de programas via apt
  - Limpeza de programas e arquivos de cache
  - Visualizar processos e estatísticas
  - etc.

  **\*Veja mais em dotfiles/.config/fish/conf.d/aliases.fish**

### 2.4. Assistir Animes (ani-cli) 📺️

- Instalação do app 'ani-cli' para assistir animes via terminal


## 3. Instalação.

    git clone https://github.com/denisduarth/dotfiles.git

###

    cd dotfiles

### 3.1 chmod +x para o install.sh.

#### \*Necessário para rodar o script!

    sudo chmod +x ./install.sh

###

    ./install.sh
