# ~/.config/fish/functions/dwd_mp3_audio.fish

function dwd_mp3_audio --description "Baixa áudio em MP3 de uma URL"
    if test -z "$argv[1]"
        echo "Uso: dwd_mp3_audio <URL>"
        return 1
    end

    set url $argv[1]
    set base_dir "$HOME/Músicas"

    mkdir -p $base_dir

    yt-dlp \
        -x \
        --audio-format mp3 \
        --audio-quality 0 \
        --no-overwrites \
        --ignore-errors \
        --embed-metadata \
        --embed-thumbnail \
        --output "$base_dir/%(title)s.%(ext)s" \
        $url
end
