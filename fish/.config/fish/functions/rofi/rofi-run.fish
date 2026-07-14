#!/usr/bin/fish
set STATE_FILE /tmp/rofi-fish-run-state
set theme_arg
if test -f /tmp/rofi-current-theme
    set -l saved_theme (cat /tmp/rofi-current-theme)
    if test -n "$saved_theme" -a -f "$saved_theme"
        set theme_arg -theme "$saved_theme"
    end
end

set NAMES \
    "Download Vídeo" \
    "Download Áudio" \
    "Download Playlist" \
    "Atualizar Sistema" \
    "Instalar Pacote" \
    "Remover Pacote" \
    "Converter ZIP para CHD"

set ICONS "" "󰎇" "󰲸" "󰚰" "󰇚" "" ""

set COMMANDS \
    "dwd_mp4_videos" \
    "dwd_mp3_audios" \
    "dwd_mp3_playlists" \
    "update" \
    "install" \
    "full_uninstall" \
    "/home/denis/.config/fish/functions/zip_to_chd.fish"

set ARG_PROMPTS \
    "URL do vídeo" \
    "URL do áudio" \
    "URL da playlist" \
    "" \
    "Nome do pacote" \
    "Nome do pacote" \
    ""

function __run_command
    set cmd $argv[1]
    if string match -q "*.fish" "$cmd"
        fish "$cmd" &
        disown
    else
        kitty -e fish -c "source ~/.config/fish/config.fish; $cmd; echo; read -P 'Pressione Enter para fechar...'" &
        disown
    end
end

set FUNCS_COUNT (count $NAMES)

if test (count $argv) -eq 0
    printf "\x00prompt\x1f\n"
    printf "\x00no-custom\x1ffalse\n"
    for i in (seq 1 $FUNCS_COUNT)
        printf "%s  %s\x00info\x1f%s\n" $ICONS[$i] $NAMES[$i] $COMMANDS[$i]
    end
    exit 0
end

if test "$argv[1]" = "--run"
    sleep 0.2
    test -f $STATE_FILE; or exit 0
    set lines (string split \n (cat $STATE_FILE))
    rm -f $STATE_FILE
    set cmd   $lines[1]
    set icon  $lines[2]
    set text  $lines[3]
    set prompt_text "$icon  $text"

    if test -n "$text"
        set arg (rofi -dmenu -i -p "$prompt_text: " $theme_arg)
        or exit
        set full_cmd "$cmd \"$arg\""
        __run_command "$full_cmd"
    else
        __run_command "$cmd"
    end
    exit 0
end

set selected (string trim "$argv[1]")
for i in (seq 1 $FUNCS_COUNT)
    if test "$selected" = (string trim "$ICONS[$i]  $NAMES[$i]")
        printf "%s\n%s\n%s" $COMMANDS[$i] $ICONS[$i] $ARG_PROMPTS[$i] > $STATE_FILE
        fish (realpath (status filename)) --run </dev/null >/dev/null 2>&1 &
        disown
        exit 0
    end
end

if test -n "$selected"
    __run_command "$selected"
    exit 0
end
