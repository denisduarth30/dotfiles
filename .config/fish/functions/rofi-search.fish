#!/usr/bin/env fish
#
# ~/.local/bin/dmsearch.fish

set DMBROWSER "firefox"
set STATE_FILE /tmp/dmsearch-state

set BANGS "!g"  "!yt"  "!tw"  "!img"  "!ddg"  "!gh"  "!gl"  "!tr"  "!wp"
set URLS \
    "https://www.google.com/search?q=" \
    "https://www.youtube.com/results?search_query=" \
    "https://twitter.com/search?q=" \
    "https://www.google.com/search?hl=en&tbm=isch&q=" \
    "https://duckduckgo.com/?q=" \
    "https://github.com/search?q=" \
    "https://gitlab.com/search?search=" \
    "https://translate.google.com/?sl=auto&tl=pt&text=" \
    "https://pt.wikipedia.org/wiki/"

set DEFAULT_URL "https://duckduckgo.com/?q="

if test (count $argv) -eq 0
    # Primeira chamada: limpa estado e mostra dica
    rm -f $STATE_FILE
    echo "!g !yt !tw !img !ddg !gh !gl !lb !tr !wp"
else
    set input $argv[1]

    if test -f $STATE_FILE
        # Segunda etapa: temos URL salva, input é a query
        set url (cat $STATE_FILE)
        rm -f $STATE_FILE
        $DMBROWSER "$url$input"
    else
        # Primeira etapa: tenta identificar o bang
        set bang (echo $input | awk '{print $1}')
        set query (echo $input | cut -d' ' -f2-)

        set url ""
        for i in (seq 1 (count $BANGS))
            if test "$bang" = "$BANGS[$i]"
                set url $URLS[$i]
                break
            end
        end

        if test -n "$url"
            if test -n "$query" -a "$query" != "$bang"
                # Bang + query na mesma linha: abre direto
                $DMBROWSER "$url$query"
            else
                # Só o bang: salva URL e pede a query
                echo $url > $STATE_FILE
                echo ""
            end
        else
            # Sem bang: DuckDuckGo direto
            $DMBROWSER "$DEFAULT_URL$input"
        end
    end
end
