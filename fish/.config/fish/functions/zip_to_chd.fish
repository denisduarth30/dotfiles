function zip_to_chd
    function __zip_to_chd_install_hint
        echo "Instale com:"
        echo "  Ubuntu/Debian: sudo apt install mame-tools unzip"
        echo "  Arch: sudo pacman -S mame-tools unzip"
        echo "  Fedora: sudo dnf install mame-tools unzip"
    end

    if test (count $argv) -eq 0
        echo "Uso: zip_to_chd jogo.zip"
        return 1
    end

    set ZIP $argv[1]

    if not test -f $ZIP
        echo "Arquivo não encontrado: $ZIP"
        return 1
    end

    if not command -q unzip; and not command -q chdman
        __zip_to_chd_install_hint
        return 1
    end

    set BASE (basename $ZIP .zip)
    set WORKDIR /tmp/$BASE

    mkdir -p $WORKDIR
    unzip -q $ZIP -d $WORKDIR

    set CUE (find $WORKDIR -iname "*.cue" | head -n 1)
    set ISO (find $WORKDIR -iname "*.iso" | head -n 1)

    if test -n "$CUE"
        set BIN (string replace ".cue" ".bin" $CUE)
        set sysconf (strings $BIN | grep -i "BOOT")

        if string match -q "*BOOT2*" $sysconf
            set DISC $CUE
            set DEST $HOME/Jogos/ps2/$BASE
        else if string match -q "*BOOT*" $sysconf
            set DISC $CUE
            set DEST $HOME/Jogos/ps1/$BASE
        else
            echo "Não foi possível detectar a plataforma para: $CUE"
            rm -rf $WORKDIR
            return 1
        end
    else
        set DISC $ISO
        set DEST $HOME/Jogos/ps2/$BASE
    end

    mkdir -p $DEST
    chdman createcd -i $DISC -o $DEST/$BASE.chd
    rm -rf $WORKDIR
    rm -f $ZIP
end
