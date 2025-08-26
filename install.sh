#!/bin/bash

# --- Function to check for internet connectivity ---
check_internet() {
    ping -c 1 archlinux.org > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Error: No internet connection. Please connect to the internet and try again."
        exit 1
    fi
}

# --- Function to install AUR helper (yay) if not present ---
install_yay() {
    if ! command -v yay &> /dev/null; then
        echo "yay not found. Installing yay from AUR..."
        sudo pacman -S --noconfirm --needed git base-devel
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf yay
        echo "yay installed successfully."
    fi
}

echo "--- Checking for internet connection... ---"
check_internet

echo "--- Installing AUR helper (yay) if needed... ---"
install_yay

echo "--- Updating system and installing base packages... ---"
sudo pacman -Syu --noconfirm --needed

echo "--- Installing core desktop packages ---"
yay -S --noconfirm --needed zsh sddm networkmanager nwg-look

echo "--- Installing Hyprland and its dependencies from AUR ---"
# This command handles conflicts and installs the -git versions
yay -S --noconfirm --needed hyprland-git hyprgraphics-git hyprcursor-git hyprland-qtutils-git hyprland-qt-support-git

echo "--- Installing PipeWire audio stack ---"
# Remove old PulseAudio packages and install PipeWire as a replacement
sudo pacman -Rns --noconfirm --needed pulseaudio pulseaudio-alsa || true
sudo pacman -S --noconfirm --needed pipewire pipewire-pulse pipewire-alsa pipewire-jack

sudo pacman -S --noconfirm --needed blueman

echo "--- Enabling systemd services for a complete setup ---"
sudo systemctl enable NetworkManager.service
sudo systemctl enable sddm.service
sudo systemctl --user enable pipewire.service
sudo systemctl --user enable pipewire-pulse.service

echo "--- Setting Zsh as the default shell for the current user ---"
chsh -s $(which zsh)

echo "--- Installation is complete! ---"
echo "You must now reboot your system to log into your new Wayland session."
echo "After rebooting, log in via SDDM and the Hyprland session should start."
echo "Don't forget to copy the Hyprland configuration files to ~/.config/hypr/."
