# ~/.config/fish/functions/dwd_mp3_playlist.fish

function dwd_mp3_playlist --description "Baixa playlist completa em MP3"
    if test -z "$argv[1]"
        echo "Uso: dwd_mp3_playlist <URL_DA_PLAYLIST>"
        return 1
    end

    set url $argv[1]
    set base_dir "$HOME/Músicas"

    mkdir -p $base_dir

    yt-dlp \
        -x \
        --audio-format mp3 \
        --audio-quality 0 \
        --yes-playlist \
        --no-overwrites \
        --ignore-errors \
        --embed-metadata \
        --embed-thumbnail \
        --restrict-filenames \
        --output "$base_dir/%(playlist_title)s/%(playlist_index)02d - %(title)s.%(ext)s" \
        $url

    echo "Playlist baixada com sucesso!"
end
