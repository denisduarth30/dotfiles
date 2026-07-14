#!/bin/bash
echo "🚀 Iniciando a configuração dos atalhos do Rofi..."

if ! command -v sxhkd &> /dev/null; then
    echo "Instalando sxhkd..."
    sudo apt update && sudo apt install -y sxhkd
fi

mkdir -p "$HOME/.config/autostart"

echo "Configurando inicialização automática do sxhkd..."
cat <<EOF > "$HOME/.config/autostart/sxhkd.desktop"
[Desktop Entry]
Type=Application
Exec=sxhkd
X-GNOME-Autostart-enabled=true
NoDisplay=false
Hidden=false
Name[pt_BR]=sxhkd
Comment[pt_BR]=Ativa o sxhkd
X-GNOME-Autostart-Delay=2
EOF

echo "🔄 Iniciando os serviços em segundo plano..."
pkill -x sxhkd
nohup sxhkd > /dev/null 2>&1 &
echo "Tudo pronto! Atalhos configurados e ativos."
