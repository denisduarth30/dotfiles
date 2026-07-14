function full_uninstall
    set pkg $argv[1]
    sudo apt remove -y $pkg; and sudo apt autopurge -y; and sudo apt autoremove -y
end
