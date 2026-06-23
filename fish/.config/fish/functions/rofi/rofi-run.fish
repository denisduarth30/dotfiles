#!/usr/bin/fish

set STATE_FILE /tmp/rofi-fish-run-state

set theme_arg
if test -f /tmp/rofi-theme-tmp.rasi
    set theme_arg -theme /tmp/rofi-theme-tmp.rasi
end

set NAMES \
    "Download Vídeo" \
    "Download Áudio" \
    "Download Playlist" \

set ICONS "" "󰎇" "󰲸"

set COMMANDS \
    "dwd_mp4_videos" \
    "dwd_mp3_audios" \
    "dwd_mp3_playlists" \

set ARG_PROMPTS \
    "URL do vídeo" \
    "URL do áudio" \
    "URL da playlist" \

set FUNCS_COUNT (count $NAMES)
set DEFAULT_TERM "kitty"

if test (count $argv) -eq 0
    printf "\x00prompt\x1f\n"

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
    set arg   ""

    set prompt_text "$icon  $text"

    if test -n "$text"
        set arg (rofi -dmenu -i -p "$prompt_text: " $theme_arg)
        or exit
    end

    $DEFAULT_TERM -e fish -c "source ~/.config/fish/config.fish; $cmd \"$arg\"; echo; read -P 'Pressione Enter para fechar...'" &
    disown
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
    $DEFAULT_TERM -e fish -c "source ~/.config/fish/config.fish; $selected; echo; read -P 'Pressione Enter para fechar...'" </dev/null >/dev/null 2>&1 &
    disown
    exit 0
end
