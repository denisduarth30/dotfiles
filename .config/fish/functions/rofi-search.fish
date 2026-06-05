#!/usr/bin/env fish
#
# ~/.config/fish/functions/rofi-search.fish

set DMBROWSER "firefox"
set STATE_FILE /tmp/dmsearch-state

set BANGS \
    "!g"     "!yt"     "!tw"     "!img"     "!ddg"     "!gh"     "!gl"     "!lb"     "!tr"     "!wp"    \
    "!g-p"   "!yt-p"   "!tw-p"   "!img-p"   "!ddg-p"   "!gh-p"   "!gl-p"   "!lb-p"   "!tr-p"   "!wp-p"

set URLS \
    "https://www.google.com/search?q=" \
    "https://www.youtube.com/results?search_query=" \
    "https://twitter.com/search?q=" \
    "https://www.google.com/search?hl=en&tbm=isch&q=" \
    "https://duckduckgo.com/?q=" \
    "https://github.com/search?q=" \
    "https://gitlab.com/search?search=" \
    "https://letterboxd.com/search/?q=" \
    "https://translate.google.com/?sl=auto&tl=pt&text=" \
    "https://pt.wikipedia.org/w/index.php?search=" \

set DEFAULT_URL "https://duckduckgo.com/?q="

if test (count $argv) -eq 0
    rm -f $STATE_FILE
    echo "!g !yt !tw !img !ddg !gh !gl !lb !tr !wp"

else
    set input $argv[1]

    if test -f $STATE_FILE
        set saved (cat $STATE_FILE)
        rm -f $STATE_FILE
        set url (echo $saved | awk '{print $1}')
        set private (echo $saved | awk '{print $2}')

        if test "$private" = "true"
            firefox --private-window "$url$input"
        else
            $DMBROWSER "$url$input"
        end

    else if string match -q '!*' $input
        set bang (echo $input | awk '{print $1}')
        set query (echo $input | cut -d' ' -f2-)

        set private false
        set lookup_bang $bang
        if string match -q '*-p' $bang
            set private true
            set lookup_bang (string replace -- '-p' '' $bang)
        end

        set url ""
        for i in (seq 1 10)
            if test "$lookup_bang" = "$BANGS[$i]"
                set url $URLS[$i]
                break
            end
        end

        test -z "$url"; and set url $DEFAULT_URL

        if test -n "$query" -a "$query" != "$bang"
            if test "$private" = "true"
                firefox --private-window "$url$query"
            else
                $DMBROWSER "$url$query"
            end
        else
            echo "$url $private" > $STATE_FILE
            echo ""
        end

    else
        $DMBROWSER "$DEFAULT_URL$input"
    end
end
