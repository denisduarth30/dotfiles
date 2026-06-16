#!/usr/bin/fish

set DMBROWSER "firefox"
set DEFAULT_URL "https://duckduckgo.com/?q="
set STATE_FILE /tmp/rofi-search-state

set NAMES \
    "Google" "YouTube" "X" "Google Images" "DuckDuckGo" \
    "GitHub" "GitLab" "Google Translate" "Wikipedia" \
    "Facebook Marketplace" "Amazon" "Pinterest" "Steam" "ProtonDB"

set ICONS "" "" "" "󰋩" "󰇥" "" "" "󰊿" "󰖬" "" "" "" "" ""

set URLS \
    "https://www.google.com/search?q=" \
    "https://www.youtube.com/results?search_query=" \
    "https://twitter.com/search?q=" \
    "https://www.google.com/search?hl=en&tbm=isch&q=" \
    "https://duckduckgo.com/?q=" \
    "https://github.com/search?q=" \
    "https://gitlab.com/search?search=" \
    "https://translate.google.com/?sl=auto&tl=pt&text=" \
    "https://pt.wikipedia.org/w/index.php?search=" \
    "https://www.facebook.com/marketplace/108568625834990/search/?query=" \
    "https://www.amazon.com.br/s?k=" \
    "https://br.pinterest.com/search/pins/?q=" \
    "https://store.steampowered.com/search?term=" \
    "https://www.protondb.com/search?q="

set BANGS "!g" "!yt" "!x" "!img" "!ddg" "!gh" "!gl" "!tr" "!wp" "!fb" "!am" "!ptr" "!st" "!ptdb"
set LISTS_COUNT (count $NAMES)

set theme_arg
if test -f /tmp/rofi-theme-tmp.rasi
    set theme_arg -theme /tmp/rofi-theme-tmp.rasi
end

function launch -a url query private
    if test "$private" = true
        $DMBROWSER --private-window "$url$query" &
    else
        $DMBROWSER "$url$query" &
    end
    disown
end

if test (count $argv) -eq 0
    set prompt_msg ""
    set suffix ""

    if test "$ROFI_PRIVATE_SEARCH" = "true"
        set prompt_msg "󰈉"
        set suffix " (Privado)"
    end

    printf "\x00prompt\x1f%s\n" "$prompt_msg"
    printf "\x00no-custom\x1ftrue\n"
    for i in (seq 1 $LISTS_COUNT)
        printf "%s  %s%s\x00info\x1f%s\n" $ICONS[$i] $NAMES[$i] $suffix $URLS[$i]
    end
    exit 0
end

if test "$argv[1]" = "--query"
    sleep 0.2
    test -f $STATE_FILE; or exit 0
    set lines (string split \n (cat $STATE_FILE))
    rm -f $STATE_FILE

    set url $lines[1]
    set name $lines[2]
    set prompt_text $name

    for i in (seq 1 $LISTS_COUNT)
        if test "$NAMES[$i]" = "$name"
            if test -n "$ICONS[$i]"
                set prompt_text "$ICONS[$i]"
            end
            break
        end
    end

    set is_private false
    if test "$ROFI_PRIVATE_SEARCH" = "true"
        set is_private true
    end

    set query (rofi -dmenu -i -p "$prompt_text " $theme_arg)
    or exit

    launch "$url" "$query" "$is_private"
    exit 0
end

set selected (string trim "$argv[1]")

set suffix ""
if test "$ROFI_PRIVATE_SEARCH" = "true"
    set suffix " (Privado)"
end

for i in (seq 1 $LISTS_COUNT)
    set expected (string trim "$ICONS[$i]  $NAMES[$i]$suffix")

    if test "$selected" = "$expected"
        printf "%s\n%s" $URLS[$i] $NAMES[$i] > $STATE_FILE
        set script_path (realpath (status filename))
        fish $script_path --query </dev/null >/dev/null 2>&1 &
        disown
        exit 0
    end
end

set input $argv[1]

if string match -q '* !*' $input
    set parts (string split ' ' $input)
    set bang $parts[-1]
    set input_text (string join ' ' $parts[1..-2])
    set input "$bang $input_text"
end

if string match -q '!*' $input
    set parts (string split ' ' $input)
    set bang  $parts[1]
    set query (string join ' ' $parts[2..])

    set private false
    if test "$ROFI_PRIVATE_SEARCH" = "true"
        set private true
    end

    if string match -q '*-p' $bang
        set private true
        set bang (string replace -r -- '-p$' '' $bang)
    end

    set url $DEFAULT_URL
    for i in (seq 1 $LISTS_COUNT)
        if test "$bang" = "$BANGS[$i]"
            set url $URLS[$i]
            break
        end
    end

    if test -n "$query"
        launch "$url" "$query" "$private"
    else
        set query (rofi -dmenu -i -p "Buscando:" $theme_arg)
        or exit
        launch "$url" "$query" "$private"
    end
else
    set private false
    if test "$ROFI_PRIVATE_SEARCH" = "true"
        set private true
    end
    launch "$DEFAULT_URL" "$input" "$private"
end
