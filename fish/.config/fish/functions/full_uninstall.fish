function _detect_pkg_manager
    if command -v paru >/dev/null 2>&1
        echo paru
    else if command -v yay >/dev/null 2>&1
        echo yay
    else if command -v pacman >/dev/null 2>&1
        echo pacman
    else if command -v dnf >/dev/null 2>&1
        echo dnf
    else if command -v apt >/dev/null 2>&1
        echo apt
    else
        echo unknown
    end
end

function full_uninstall
    set pkg $argv[1]
    set pm (_detect_pkg_manager)

    switch $pm
        case paru yay
            $pm -Rns --noconfirm $pkg
        case pacman
            sudo pacman -Rns --noconfirm $pkg
        case dnf
            sudo dnf remove -y $pkg; and sudo dnf autoremove -y
        case apt
            sudo apt remove -y $pkg; and sudo apt autopurge -y; and sudo apt autoremove -y
        case '*'
            echo "Gerenciador de pacotes não suportado."
            return 1
    end
end
