#!/usr/bin/env bash

# set -e # exit immediately if a command exits with a non-zero status

CONFIG="conf.yaml"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install yay
if ! command -v yay &> /dev/null; then
  cd ~
  pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
  cd "${BASEDIR}"

fi

yay -S --noconfirm --needed dotbot
yay -S --noconfirm --needed zsh oh-my-zsh-git oh-my-zsh-autosuggestions-git oh-my-syntax-highlighting-git
yay -S --noconfirm --needed whitesur-cursor-theme-git whitesur-gtk-theme-git whitesur-icon-theme-git

cd "${BASEDIR}"

# Install dotfiles
dotbot -d "${BASEDIR}" -c "${CONFIG}" "${@}" || {
  echo "Error: Dotbot installation failed!"
  exit 1
}

# Update the system
# sudo pacman -Syu --noconfirm

# Check if the file exists
# if [ -f "packages.txt" ]; then
#   # Read the package names from the file and install them
#   while read -r package; do
#     yay -S --noconfirm --needed "$package"
#   done < packages.txt
#   echo "All user-installed packages have been installed."
# else
#   echo "The file 'packages.txt' does not exist."
# fi

# Update the package list
# yay -Qqe > packages.txt

# Ensure services are enabled
# sudo systemctl enable NetworkManager.service
# sudo systemctl enable bluetooth.service
# sudo systemctl enable bluetooth-mesh.service
# sudo systemctl enable blueman-mechanism.service
# sudo systemctl enable gpm.service
# sudo systemctl enable systemd-homed-activate.service
# sudo systemctl enable systemd-homed.service
# sudo systemctl enable avahi-daemon.service
# sudo systemctl enable sshd.service
# sudo systemctl enable cockpit.socket
# sudo systemctl enable docker.service
# sudo systemctl enable upower.service
sudo systemctl enable nvidia-persistenced.service
sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-resume.service
sudo systemctl enable nvidia-hibernate.service

# Update mkinitcpio and grub
sudo mkinitcpio -P
sudo update-grub

# Update dotfiles repo
git add . || true
git commit -m "update dotfiles" || true
git push origin main
