# ~/.config/fish/functions/dwd_mp4_video.fish

function dwd_mp4_video --description "Baixa vídeo em MP4 de uma URL"
    if test -z "$argv[1]"
        echo "Uso: dwd_mp4_video <URL> [qualidade: 1080|720|480|360|best]"
        echo "Qualidade padrão: best"
        return 1
    end

    set url $argv[1]
    set quality $argv[2]
    set base_dir "$HOME/Vídeos"

    mkdir -p $base_dir

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

    yt-dlp \
        --format $format \
        --merge-output-format mp4 \
        --no-overwrites \
        --ignore-errors \
        --embed-metadata \
        --embed-thumbnail \
        --js-runtimes deno \
        --embed-subs \
        --output "$base_dir/%(title)s.%(ext)s" \
        $url

    echo "Download concluído em $base_dir"
end
