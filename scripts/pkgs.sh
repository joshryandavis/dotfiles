#!/usr/bin/env bash

# https://github.com/JaKooLit

# edit your packages desired here. 
# WARNING! If you remove packages here, dotfiles may not work properly.
# and also, ensure that packages are present in AUR and official Arch Repo

# add packages wanted here
Extra=(
jetbrains-toolbox
visual-studio-code-bin
tmux
udiskie
dunst
swaync
mdp
alacritty
zsh
flatpak
fzf
git
wget
bluez
pipewire
wireplumber
pipewire-pulse
)

thunar=(
thunar 
thunar-volman 
tumbler 
thunar-archive-plugin
)

hypr_package=( 
cliphist
dunst 
foot
grim 
gvfs 
gvfs-mtp 
jq  
network-manager-applet 
pamixer 
pavucontrol
wlr-randr
pipewire-alsa 
playerctl
polkit-kde-agent 
python-requests 
qt5ct 
slurp 
swappy 
swayidle 
swaylock-effects 
swww 
waybar
wget
wl-clipboard
wofi 
xdg-user-dirs 
brightnessctl 
btop
cava
ffmpegthumbs
gnome-system-monitor
mousepad 
mpv 
nvtop
nwg-look-bin
swaybg
viewnior
vim
wlsunset
openssh
samba
cockpi
)

fonts=(
adobe-source-code-pro-fonts 
ttf-apple-emoji
apple-fonts
ttf-ms-fonts
otf-font-awesome 
otf-font-awesome-4 
ttf-jetbrains-mono 
ttf-droid 
ttf-fira-code
ttf-jetbrains-mono 
ttf-jetbrains-mono-nerd 
)


############## WARNING DO NOT EDIT BEYOND THIS LINE if you dont know what you are doing! ######################################

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Set the name of the log file to include the current date and time
LOG="logs/install-$(date +%d-%H%M%S)_hypr-pkgs.log"

ISAUR=$(command -v yay || command -v paru)

# Set the script to exit on error
set -e

# Function for installing packages
install_package() {
  # Checking if package is already installed
  if $ISAUR -Q "$1" &>> /dev/null ; then
    echo -e "${OK} $1 is already installed. Skipping..."
  else
    # Package not installed
    echo -e "${NOTE} Installing $1 ..."
    $ISAUR -S --noconfirm "$1" 2>&1 | tee -a "$LOG"
    # Making sure package is installed
    if $ISAUR -Q "$1" &>> /dev/null ; then
      echo -e "\e[1A\e[K${OK} $1 was installed."
    else
      # Something is missing, exiting to review log
      echo -e "\e[1A\e[K${ERROR} $1 failed to install :( , please check the install.log. You may need to install manually! Sorry I have tried :("
      exit 1
    fi
  fi
}

# Installation of main components
printf "\n%s - Installing hyprland packages.... \n" "${NOTE}"

for PKG1 in "${hypr_package[@]}" "${fonts[@]}" "${Extra[@]}" "${thunar[@]}"; do
  install_package "$PKG1" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed, please check the install.log"
    exit 1
  fi
done
