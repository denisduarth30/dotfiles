#!/usr/bin/fish

set STATE_FILE /tmp/rofi-fish-power-state
set theme_arg
if test -f /tmp/rofi-current-theme
    set -l saved_theme (cat /tmp/rofi-current-theme)
    if test -n "$saved_theme" -a -f "$saved_theme"
        set theme_arg -theme "$saved_theme"
    end
end

set NAMES \
    "Desligar" \
    "Reiniciar" \
    "Suspender" \
    "Hibernar" \
    "Sair" \
    "Ir para a BIOS"

set ICONS \
    "⏻" \
    "" \
    "󰤄" \
    "󰒲" \
    "󰍃" \
    ""

set COMMANDS \
    "poweroff" \
    "reboot" \
    "suspend" \
    "hibernate" \
    "logout" \
    "bios"

set FUNCS_COUNT (count $NAMES)

if test (count $argv) -eq 0
    printf "\x00prompt\x1f⏻\n"
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
        case poweroff
            systemctl poweroff
        case reboot
            systemctl reboot
        case suspend
            systemctl suspend
        case hibernate
            systemctl hibernate
        case logout
            loginctl terminate-user $USER
        case bios
            systemctl reboot --firmware-setup
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
