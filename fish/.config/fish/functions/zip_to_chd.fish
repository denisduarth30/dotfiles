#!/usr/bin/env fish

function __process_conversion
    set -l FILE $argv[1]
    set -l SOURCE_DIR "$HOME/Downloads"
    set -l PS1_DEST "$HOME/Jogos/ps1"
    set -l PS2_DEST "$HOME/Jogos/ps2"

    set -l BASE (basename "$FILE" | sed 's/\(.*\)\.\(zip\|7z\|rar\|tar\.gz\)/\1/')
    set -l WORKDIR /tmp/$BASE

    notify-send -t 3000 "Extraindo..." "Iniciando a extração de $BASE"
    mkdir -p $WORKDIR
    7z x "$FILE" -o"$WORKDIR" -y > /dev/null

    set ALL_CUES (find $WORKDIR -type f -iname "*.cue")
    set SELECTED_DISC ""
    set PLATFORM ""
    set MAX_SIZE 0

    for CUE_FILE in $ALL_CUES
        set BIN_FILE (find (dirname $CUE_FILE) -maxdepth 1 -iname "*.bin" | head -n 1)
        if test -n "$BIN_FILE"
            set sysconf (strings "$BIN_FILE" | grep -i "BOOT")
            if string match -q "*BOOT2*" $sysconf
                set TYPE "PS2"
            else if string match -q "*BOOT*" $sysconf
                set TYPE "PS1"
            else
                continue
            end
            set SIZE (du -b "$BIN_FILE" | cut -f1)
            if test $SIZE -gt $MAX_SIZE
                set MAX_SIZE $SIZE
                set SELECTED_DISC $CUE_FILE
                set PLATFORM $TYPE
            end
        end
    end

    if test -z "$SELECTED_DISC"
        set ISO (find $WORKDIR -type f -iname "*.iso" | head -n 1)
        if test -n "$ISO"
            set SELECTED_DISC $ISO
            set PLATFORM "PS2"
        end
    end

    if test -n "$SELECTED_DISC"
        set DEST (if test "$PLATFORM" = "PS2"; echo "$PS2_DEST/$BASE"; else; echo "$PS1_DEST/$BASE"; end)
    else
        notify-send -u critical "Erro" "Nenhum disco selecionado para $BASE."
        rm -rf $WORKDIR
        return 1
    end

    mkdir -p "$DEST"
    notify-send -t 5000 "Convertendo ($PLATFORM)" "Criando $BASE.chd..."

    if chdman createcd -i "$SELECTED_DISC" -o "$DEST/$BASE.chd"
        notify-send -u normal "Concluído" "O jogo $BASE foi salvo com sucesso!"
        rm -rf $WORKDIR
        rm -f "$FILE"
    else
        notify-send -u critical "Erro" "Falha no chdman para $BASE."
        rm -rf $WORKDIR
    end
end

set SOURCE_DIR "$HOME/Downloads"
set theme_arg
if test -f /tmp/rofi-current-theme
    set -l saved_theme (cat /tmp/rofi-current-theme)
    if test -n "$saved_theme" -a -f "$saved_theme"
        set theme_arg -theme "$saved_theme"
    end
end

set FOUND_FILES (find $SOURCE_DIR -maxdepth 1 -type f \( -iname "*.zip" -o -iname "*.7z" \))

if test (count $FOUND_FILES) -eq 0
    notify-send -u normal "Conversor ZIP/7z" "Nenhum arquivo .zip ou .7z encontrado em $SOURCE_DIR"
    exit 0
end

set FILE_LIST (printf "%s\n" $FOUND_FILES | xargs -I {} basename {} | awk '{print "  " $0}')

set SELECTED (printf "%s\n" $FILE_LIST | rofi -dmenu -i -p "" -no-custom $theme_arg -theme-str "element-icon { enabled: false; } element { spacing: 0px; }")

if test -z "$SELECTED"
    exit 0
end

set FILE_NAME (string replace -r "^\s+" "" "$SELECTED")
set FULL_PATH "$SOURCE_DIR/$FILE_NAME"

__process_conversion "$FULL_PATH" &
disown
exit 0
