#!/usr/bin/fish

set STATE_FILE /tmp/rofi-fish-run-state
set theme_arg

if test -f /tmp/rofi-current-theme
    set -l saved_theme (cat /tmp/rofi-current-theme)
    if test -n "$saved_theme" -a -f "$saved_theme"
        set theme_arg -theme "$saved_theme"
    end
end

set NAMES "Download Vídeo" "Download Áudio" "Download Playlist" "Atualizar Sistema" "Instalar Pacote" "Remover Pacote" "Converter ZIP para CHD"
set ICONS "" "󰎇" "󰲸" "󰚰" "󰇚" "" ""
set COMMANDS "dwd_mp4_videos" "dwd_mp3_audios" "dwd_mp3_playlists" "update" "install" "full_uninstall" "/home/denis/.config/fish/functions/zip_to_chd.fish"
set ARG_PROMPTS "URL do vídeo" "URL do áudio" "URL da playlist" "" "Nome do pacote" "Nome do pacote" ""

set SUDO_COMMANDS "update" "install" "full_uninstall"
set MAIN_ICON ""

set TERMINAL (rofi -dump-config | grep -oP 'terminal: "\K[^"]+' | head -1)

function __create_askpass
    set askpass_script /tmp/rofi-askpass.fish
    echo '#!/usr/bin/fish' > $askpass_script
    if test -n "$theme_arg"
        echo "rofi -dmenu -password -p '󰌾' $theme_arg -no-fixed-num-lines < /dev/null" >> $askpass_script
    else
        echo "rofi -dmenu -password -p '󰌾' -no-fixed-num-lines < /dev/null" >> $askpass_script
    end
    chmod +x $askpass_script
    echo $askpass_script
end

function __run_command
    set cmd $argv[1]
    set base_cmd (string split ' ' $cmd)[1]
    set needs_sudo 0

    if contains -- $base_cmd $SUDO_COMMANDS
        set needs_sudo 1
    end

    set sudo_prefix ''
    if test $needs_sudo -eq 1
        set askpass (__create_askpass)
        set -gx SUDO_ASKPASS $askpass
        set sudo_prefix 'alias sudo "sudo -A"; sudo -v; '
    end

    if string match -q "*.fish" "$cmd"
        fish "$cmd" </dev/null >/dev/null 2>&1 &
        disown
    else
        $TERMINAL -e fish -c "source ~/.config/fish/config.fish; $sudo_prefix$cmd; echo; read -P 'Pressione Enter para fechar...'" </dev/null >/dev/null 2>&1 &
        disown
    end
end

set FUNCS_COUNT (count $NAMES)

if test (count $argv) -eq 0
    printf "\x00prompt\x1f$MAIN_ICON\n"
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
        set full_cmd "$cmd "$arg""
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
    printf "%s\n\n\n" "$selected" > $STATE_FILE
    fish (realpath (status filename)) --run </dev/null >/dev/null 2>&1 &
    disown
    exit 0
end
