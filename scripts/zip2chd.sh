#!/usr/bin/env bash

# Verifica argumento
if [ -z "$1" ]; then
  echo "Uso: $0 jogo.zip"
  exit 1
fi

read -p "Console desejado: " CONSOLE 

ZIP="$1"
BASE=$(basename "$ZIP" .zip)
WORKDIR="/tmp/$BASE"

if [ "$CONSOLE" == "ps1" ]; then
	DEST="/home/$USER/Games/ps1/$BASE"
else
	DEST="/home/$USER/Games/ps2/$BASE"
fi

echo "Criando diretórios..."
mkdir -p "$WORKDIR"
mkdir -p "$DEST"

echo "Extraindo ZIP..."
unzip -q "$ZIP" -d "$WORKDIR"

# Procura arquivos de disco
CUE=$(find "$WORKDIR" -iname "*.cue" | head -n 1)
ISO=$(find "$WORKDIR" -iname "*.iso" | head -n 1)

if [ -n "$CUE" ]; then
  DISC="$CUE"
  echo "Arquivo CUE encontrado."
elif [ -n "$ISO" ]; then
  DISC="$ISO"
  echo "Arquivo ISO encontrado."
else
  echo "Nenhum arquivo ISO ou CUE encontrado!"
  exit 1
fi

echo "Convertendo para CHD..."
chdman createcd -i "$DISC" -o "$DEST/$BASE.chd"

echo "Limpando arquivos temporários..."
rm -rf "$WORKDIR"

echo "Removendo ZIP original..."
rm --force "$ZIP"

echo "Concluído!"
echo "Arquivo final em: $DEST/$BASE.chd"
