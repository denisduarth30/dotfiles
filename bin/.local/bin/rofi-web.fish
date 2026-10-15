#!/usr/bin/fish

set DMBROWSER "firefox"
set DEFAULT_URL "https://duckduckgo.com/?q="
set STATE_FILE /tmp/rofi-fish-search-state

set NAMES \
    "Google" "YouTube" "YouTube Music" "X" "Google Images" "DuckDuckGo" \
    "GitHub" "GitLab" "Google Translate" "Wikipedia" \
    "Facebook Marketplace" "Amazon" "Pinterest" "Steam" "ProtonDB" \
    "Reddit" "Anna's Archive" "SteamDB"

set ICONS "" "" "󰎆" "" "󰋩" "󰇥" "" "" "󰊿" "󰖬" "" "" "" "" "" "" "" ""

set URLS \
    "https://www.google.com/search?q=" \
    "https://www.youtube.com/results?search_query=" \
    "https://music.youtube.com/search?q=" \
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
    "https://www.protondb.com/search?q=" \
    "https://www.reddit.com/search/?q=" \
    "https://annas-archive.pk/search?q=" \
    "https://steamdb.info/search/?a=all&q="

set LISTS_COUNT (count $NAMES)

set is_private false
if test "$ROFI_PRIVATE_SEARCH" = "true"
    set is_private true
end

set theme_arg
if test -f /tmp/rofi-current-theme
    set -l saved_theme
    read -l saved_theme < /tmp/rofi-current-theme
    if test -n "$saved_theme" -a -f "$saved_theme"
        set theme_arg -theme "$saved_theme"
    end
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

    if test "$is_private" = true
        set prompt_msg "󰈉"
        set suffix " (Privado)"
    end

    printf "\x00prompt\x1f%s\n" "$prompt_msg"
    printf "\x00no-custom\x1ftrue\n"
    for i in (seq 1 $LISTS_COUNT)
        printf "%s  %s%s\x00info\x1f%s\n" $ICONS[$i] $NAMES[$i] $suffix $i
    end
    exit 0
end

if test "$argv[1]" = "--query"
    sleep 0.2
    test -f $STATE_FILE; or exit 0
    set -l idx
    read -l idx < $STATE_FILE
    rm -f $STATE_FILE

    set url $URLS[$idx]
    set prompt_text $NAMES[$idx]
    if test -n "$ICONS[$idx]"
        set prompt_text $ICONS[$idx]
    end

    set query (rofi -dmenu -i -p "$prompt_text " $theme_arg)
    or exit

    launch "$url" "$query" "$is_private"
    exit 0
end

if test -n "$ROFI_INFO"
    printf "%s" "$ROFI_INFO" > $STATE_FILE
    set script_path (realpath (status filename))
    fish $script_path --query </dev/null >/dev/null 2>&1 &
    disown
    exit 0
end

launch "$DEFAULT_URL" "$argv[1]" "$is_private"
