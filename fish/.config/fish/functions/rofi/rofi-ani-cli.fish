#!/usr/bin/fish

set STATE_FILE /tmp/rofi-fish-ani-cli-state
set theme_arg
if test -f /tmp/rofi-current-theme
    set -l saved_theme (cat /tmp/rofi-current-theme)
    if test -n "$saved_theme" -a -f "$saved_theme"
        set theme_arg -theme "$saved_theme"
    end
end

set NAMES \
    "Pesquisar Anime" \
    "Baixar Anime" \
    "Continuar Assistindo" \
    "Histórico"

set ICONS \
    "" \
    "󰇚" \
    "" \
    ""

set COMMANDS \
    "watch" \
    "download" \
    "continue" \
    "history"

set MAIN_ICON ""
set FUNCS_COUNT (count $NAMES)
set TERMINAL (rofi -dump-config | grep -oP 'terminal: "\K[^"]+' | head -1)

if test (count $argv) -eq 0
    printf "\x00prompt\x1f$MAIN_ICON\n"
    printf "\x00no-custom\x1ftrue\n"
    for i in (seq 1 $FUNCS_COUNT)
        printf "%s  %s\x00info\x1f%s\n" $ICONS[$i] $NAMES[$i] $COMMANDS[$i]
    end
    exit 0
end

if test "$argv[1]" = "--run"
    sleep 0.2
    test -f $STATE_FILE; or exit 0
    set cmd (cat $STATE_FILE)
    rm -f $STATE_FILE

    switch $cmd
        case watch
            set query (rofi -dmenu -i -p "" $theme_arg)
            or exit 0
            test -n "$query"; or exit 0
            set q (string escape -- $query)
            $TERMINAL -e fish -c "ani-cli $q; echo; read -P 'Pressione Enter para fechar...'" &
            disown
        case download
            set query (rofi -dmenu -i -p "󰇚" $theme_arg)
            or exit 0
            test -n "$query"; or exit 0
            set q (string escape -- $query)
            $TERMINAL -e fish -c "ani-cli -d $q; echo; read -P 'Pressione Enter para fechar...'" &
            disown
        case continue
            $TERMINAL -e fish -c "ani-cli -c; echo; read -P 'Pressione Enter para fechar...'" &
            disown
        case history
            $TERMINAL -e fish -c "ani-cli -H; echo; read -P 'Pressione Enter para fechar...'" &
            disown
    end
    exit 0
end

set selected (string trim "$argv[1]")

for i in (seq 1 $FUNCS_COUNT)
    if test "$selected" = (string trim "$ICONS[$i]  $NAMES[$i]")
        printf "%s" $COMMANDS[$i] > $STATE_FILE
        fish (realpath (status filename)) --run </dev/null >/dev/null 2>&1 &
        disown
        exit 0
    end
end

exit 0
