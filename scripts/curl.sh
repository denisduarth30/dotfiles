install_rust() {
    if ! command -v rustc >/dev/null; then
      echo "Instalando Rust..."
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup.sh
      sh rustup.sh -y
      rm rustup.sh
    fi
}

install_zed(){
    if ! command -v zed >/dev/null; then
        echo "Instalando Zed..."
        curl -fsS https://zed.dev/install.sh | sh
    fi
}

install_node(){
    if [ ! -d "$HOME/.nvm" ]; then
      echo "Instalando NVM..."
      curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh -o nvm_install.sh
      bash nvm_install.sh
      rm nvm_install.sh
    fi
    
    export NVM_DIR="$HOME/.nvm"
    
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    
    if ! command -v node >/dev/null; then
      nvm install --lts
    fi
}

install_ohmyzsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
      echo "Instalando Oh My Zsh..."
      curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o omz_install.sh
      sh omz_install.sh --unattended
      rm omz_install.sh
    fi
}

install_rust
install_zed
install_node
install_ohmyzsh