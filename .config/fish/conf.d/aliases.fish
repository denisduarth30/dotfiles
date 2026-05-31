alias home "cd ~"
alias dwd "cd $HOME/Downloads"
alias ls "eza -lha --git"
alias disks "df -h"
alias ff "fastfetch"
alias bios "sudo systemctl reboot --firmware-setup"
alias cat "batcat"
alias mkdir "mkdir -pv"

if command -v paru >/dev/null 2>&1
    alias install "paru -S --noconfirm"
    alias uninstall "paru -Rns"
    alias update "paru -Syu --noconfirm"

else if command -v yay >/dev/null 2>&1
    alias install "yay -S --noconfirm"
    alias uninstall "yay -Rns"
    alias update "yay -Syu --noconfirm"

else if command -v pacman >/dev/null 2>&1
    alias install "sudo pacman -S --noconfirm"
    alias uninstall "sudo pacman -Rns"
    alias update "sudo pacman -Syu --noconfirm"

else if command -v apt >/dev/null 2>&1
    alias install "sudo apt install -y"
    alias uninstall "sudo apt remove -y"
    alias update "sudo apt update && sudo apt upgrade -y"

else if command -v dnf >/dev/null 2>&1
    alias install "sudo dnf install -y"
    alias uninstall "sudo dnf remove -y"
    alias update "sudo dnf upgrade -y"

else if command -v zypper >/dev/null 2>&1
    alias install "sudo zypper install -y"
    alias uninstall "sudo zypper remove -y"
    alias update "sudo zypper update -y"

else if command -v xbps-install >/dev/null 2>&1
    alias install "sudo xbps-install -y"
    alias uninstall "sudo xbps-remove -y"
    alias update "sudo xbps-install -Syu"

else if command -v emerge >/dev/null 2>&1
    alias install "sudo emerge"
    alias uninstall "sudo emerge --depclean"
    alias update "sudo emerge --sync && sudo emerge -uDU @world"

else if command -v apk >/dev/null 2>&1
    alias install "sudo apk add"
    alias uninstall "sudo apk del"
    alias update "sudo apk update && sudo apk upgrade"

else if command -v brew >/dev/null 2>&1
    alias install "brew install"
    alias uninstall "brew uninstall"
    alias update "brew update && brew upgrade"

else
    echo "Nenhum gerenciador de pacotes reconhecido encontrado..."
end

alias cpu "lscpu"
alias memory "free -h"
alias mounts "mount | column -t"
alias psaux "ps aux"
alias psg "ps aux | grep -v grep | grep -i"
alias lsblk "lsblk -f"
alias ssd "df -h | grep sda"
alias man "tldr"
alias kernel "uname -r"
alias c "clear"
alias network_restart "sudo systemctl restart NetworkManager"
alias audio_restart "systemctl --user restart pipewire"
