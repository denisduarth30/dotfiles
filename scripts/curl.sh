#!/bin/bash
set -e

install_rust() {
    if ! command -v rustc >/dev/null; then
      echo "Instalando Rust..."
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    fi
}

install_zed(){
    if ! command -v zed >/dev/null; then
        echo "Instalando Zed..."
        curl -fsS https://zed.dev/install.sh | sh
    fi
}

install_deno() {
    if ! command -v deno >/dev/null; then
        echo "Instalando Deno..."
        curl -fsSL https://deno.land/install.sh | sh
    fi
}

install_rust
install_zed
install_deno
