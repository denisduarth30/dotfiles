#!/bin/bash

echo "🚀 Iniciando a configuração dos atalhos do Rofi..."

install_keysuperkey() {
    echo "Compilando ksuperkey a partir do fonte..."
    sudo apt install git gcc make libx11-dev libxtst-dev pkg-config

    cd /tmp
    rm -rf ksuperkey
    git clone https://github.com/hanschen/ksuperkey.git
    cd ksuperkey
    make
    sudo make install

    cd - > /dev/null
}

if ! command -v sxhkd &> /dev/null; then
    echo "Instalando sxhkd..."
    sudo apt update && sudo apt install -y sxhkd
fi

if ! command -v ksuperkey &> /dev/null; then
    echo "Instalando ksuperkey..."
    install_keysuperkey
fi

mkdir -p "$HOME/.config/autostart"

echo "Configurando inicialização automática do sxhkd..."
cat <<EOF > "$HOME/.config/autostart/sxhkd.desktop"
[Desktop Entry]
Type=Application
Exec=sh -c "sleep 2 && sxhkd"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=sxhkd
Comment=Gerenciador de atalhos do Rofi
EOF

echo "Configurando inicialização automática do ksuperkey..."
cat <<EOF > "$HOME/.config/autostart/ksuperkey.desktop"
[Desktop Entry]
Type=Application
Exec=ksuperkey -e 'Super_L=Super_L|Escape'
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=ksuperkey
Comment=Mapeia toque na tecla Super para Super+Escape
EOF

echo "🔄 Iniciando os serviços em segundo plano..."
pkill -x sxhkd
pkill -x ksuperkey
nohup sxhkd > /dev/null 2>&1 &
nohup ksuperkey -e 'Super_L=Super_L|Escape' > /dev/null 2>&1 &

echo "Tudo pronto! Atalhos configurados e ativos."
