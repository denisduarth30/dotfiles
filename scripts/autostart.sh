#!/bin/bash
set -euo pipefail

SYSTEMD_USER_DIR="$HOME/.config/systemd/user"
AUTOSTART_DIR="$HOME/.config/autostart"

echo "Iniciando a configuração dos atalhos do Rofi..."

if ! command -v sxhkd &>/dev/null; then
    echo "Instalando sxhkd..."
    sudo apt update && sudo apt install -y sxhkd
fi

if ! command -v xcape &>/dev/null; then
    echo "Instalando xcape..."
    sudo apt install -y xcape
fi

for old in "$AUTOSTART_DIR/sxhkd.desktop" "$AUTOSTART_DIR/ksuperkey.desktop"; do
    if [[ -f "$old" ]]; then
        echo "Removendo arquivo legado: $old"
        rm -f "$old"
    fi
done

pkill -x ksuperkey 2>/dev/null && echo "ksuperkey parado" || true

mkdir -p "$SYSTEMD_USER_DIR"

echo "Criando xcape.service..."
cat > "$SYSTEMD_USER_DIR/xcape.service" <<'EOF'
[Unit]
Description=xcape – mapeia toque no Super para Super+Escape
After=graphical-session.target
PartOf=graphical-session.target

[Service]
ExecStart=/usr/bin/xcape -e 'Super_L=Super_L|Escape'
Restart=always
RestartSec=2
Environment=DISPLAY=:0

[Install]
WantedBy=graphical-session.target
EOF

echo "Criando sxhkd.service..."
cat > "$SYSTEMD_USER_DIR/sxhkd.service" <<'EOF'
[Unit]
Description=sxhkd – hotkey daemon
After=xcape.service
Requires=xcape.service

[Service]
ExecStartPre=/bin/sleep 2
ExecStart=/usr/bin/sxhkd
Restart=always
RestartSec=2
Environment=DISPLAY=:0

[Install]
WantedBy=graphical-session.target
EOF

echo "Recarregando daemon do systemd..."
systemctl --user daemon-reload

echo "Habilitando serviços para iniciar com a sessão..."
systemctl --user enable xcape.service sxhkd.service

systemctl --user stop xcape.service sxhkd.service 2>/dev/null || true
pkill -x sxhkd 2>/dev/null || true

echo "Iniciando serviços..."
systemctl --user start xcape.service
systemctl --user start sxhkd.service

systemctl --user status xcape.service --no-pager -l
systemctl --user status sxhkd.service --no-pager -l
