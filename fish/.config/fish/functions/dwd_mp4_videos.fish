# ~/.config/fish/functions/dwd_mp4_video.fish

function dwd_mp4_videos --description "Baixa vídeo(s) em MP4 de uma ou mais URLs"
    if test (count $argv) -eq 0
        echo "Uso: dwd_mp4_video [-q 1080|720|480|360] <URL1> <URL2> ..."
        echo "Qualidade padrão: best"
        return 1
    end

    set base_dir "$HOME/Vídeos"
    set quality "best"
    set urls

    # Parseia -q como flag opcional
    set i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case '-q'
                set i (math $i + 1)
                set quality $argv[$i]
            case '*'
                set urls $urls $argv[$i]
        end
        set i (math $i + 1)
    end

    if test (count $urls) -eq 0
        echo "Erro: nenhuma URL fornecida."
        return 1
    end

    switch $quality
        case 1080
            set format "bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[height<=1080][ext=mp4]/best"
        case 720
            set format "bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]/best[height<=720][ext=mp4]/best"
        case 480
            set format "bestvideo[height<=480][ext=mp4]+bestaudio[ext=m4a]/best[height<=480][ext=mp4]/best"
        case 360
            set format "bestvideo[height<=360][ext=mp4]+bestaudio[ext=m4a]/best[height<=360][ext=mp4]/best"
        case '*'
            set format "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"
    end

    mkdir -p $base_dir

    set success_count 0
    set fail_count 0
    set failed_urls

    for url in $urls
        echo ""
        echo "⬇ Baixando: $url"

        yt-dlp \
            --format $format \
            --merge-output-format mp4 \
            --no-overwrites \
            --ignore-errors \
            --embed-metadata \
            --embed-thumbnail \
            --js-runtimes deno \
            --embed-subs \
            --no-warnings \
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
    echo "✓ Sucesso: $success_count  |  Destino: $base_dir"
    echo "✗ Falhas:  $fail_count"

    if test (count $failed_urls) -gt 0
        echo ""
        echo "URLs que falharam:"
        for u in $failed_urls
            echo "  - $u"
        end
    end
end
