# Arch Linux Hyprland Setup

This repo contains my setup for Arch Linux with the Hyprland Wayland compositor.

```bash
git clone [https://github.com/your-username/your-repo-name.git](https://github.com/your-username/your-repo-name.git)
cd your-repo-name
chmod +x install.sh
./install.sh
cp -r .config/hypr ~/.config/
sudo reboot
```



external usb devices not detected 

## gnome as alternative (GDM to switch )
```bash
sudo pacman -S gdm
sudo systemctl enable --now gdm
sudo pacman -S gnome-control-center gnome-bluetooth chrome-gnome-shell gnome-tweaks
```

GNOME on Wayland cannot be restarted with Alt+F2 → r; log out and log back in instead.

if an issue occured and gnome is forzen, switch to another tty
Ctrl + Alt + F2 for tty2 ..

to restart gdm 
```bash
sudo systemctl restart gdm
```
