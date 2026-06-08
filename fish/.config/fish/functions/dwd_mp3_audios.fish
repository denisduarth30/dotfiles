# ~/.config/fish/functions/dwd_mp3_audio.fish

function dwd_mp3_audios --description "Baixa áudio em MP3 de uma ou mais URLs"
    if test (count $argv) -eq 0
        echo "Uso: dwd_mp3_audio <URL1> <URL2> ..."
        return 1
    end

    set base_dir "$HOME/Músicas"
    mkdir -p $base_dir

    set success_count 0
    set fail_count 0
    set failed_urls

    for url in $argv
        echo ""
        echo "⬇ Baixando: $url"

        yt-dlp \
            -x \
            --audio-format mp3 \
            --audio-quality 0 \
            --no-overwrites \
            --ignore-errors \
            --embed-metadata \
            --embed-thumbnail \
            --js-runtimes deno \
            --output "$base_dir/%(title)s.%(ext)s" \
            $url

        if test $status -eq 0
            set success_count (math $success_count + 1)
            echo "✓ Concluído!"
        else
            set fail_count (math $fail_count + 1)
            set failed_urls $failed_urls $url
            echo "✗ Falhou, continuando..."
        end
    end

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✓ Sucesso: $success_count"
    echo "✗ Falhas:  $fail_count"

    if test (count $failed_urls) -gt 0
        echo ""
        echo "URLs que falharam:"
        for u in $failed_urls
            echo "  - $u"
        end
    end
end
