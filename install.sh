#!/usr/bin/env bash

# set -e # exit immediately if a command exits with a non-zero status

CONFIG="conf.yaml"
DOTBOT_DIR="_dotbot"
DOTBOT_BIN="bin/dotbot"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${BASEDIR}"

# Update submodule
git submodule sync --recursive
git submodule update --recursive

# Install dotfiles
"${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}" || {
  echo "Error: Dotbot installation failed!"
  exit 1
}

# if ~/.oh-my-zsh/custom/plugins exists and isn't a link, delete it
if [ -d ~/.oh-my-zsh/custom/plugins ] && [ ! -L ~/.oh-my-zsh/custom/plugins ]; then
  rm -rf ~/.oh-my-zsh/custom/plugins
fi
# if oh-my-zsh is not installed, install it
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Update the system
sudo pacman -Syu --noconfirm

# Check if the file exists
if [ -f "packages.txt" ]; then
  # Read the package names from the file and install them
  while read -r package; do
    yay -S --noconfirm --needed "$package"
  done < packages.txt
  echo "All user-installed packages have been installed."
else
  echo "The file 'packages.txt' does not exist."
fi

# Update the package list
yay -Qqe > packages.txt

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
# sudo systemctl enable nvidia-persistenced.service
# sudo systemctl enable nvidia-suspend.service
# sudo systemctl enable nvidia-resume.service
# sudo systemctl enable nvidia-hibernate.service

# Update mkinitcpio and grub
sudo mkinitcpio -P
sudo update-grub

# Update dotfiles repo
git add . || true
git commit -m "update dotfiles" || true
git push origin main
