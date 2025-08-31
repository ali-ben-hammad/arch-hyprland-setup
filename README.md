# Arch Linux Hyprland Setup

This repo contains my setup for Arch Linux with the Hyprland Wayland compositor.

```bash
chmod +x install.sh
./install.sh
cp -r .config/hypr ~/.config/
sudo reboot
```

# Fix USB/Bluetooth missing after suspend by resetting xHCI on resume 

## Summary

- **Symptom**: After suspend/resume, all USB devices and Bluetooth disappear until reboot.
- **Cause**: The USB 3.x host controller (xHCI) can get stuck after resume. Resetting the controller (unbind/bind) brings it back.
- **Scope**: GNOME/GDM, Hyprland, etc. Same root cause; not DE-specific. Common on Intel PCH xHCI at `0000:00:14.0`.

## What is xHCI?

- **xHCI** = eXtensible Host Controller Interface, the standard USB 3.x host controller used by modern chipsets.
- It manages most USB ports and often the internal Bluetooth device (which explains why both USB and BT die together).

## Find your xHCI PCI device ID

  ```bash
  lspci -nn | grep -i 'usb controller'
  ```

  Note: `lspci` prints `00:14.0`; prepend `0000:` to use with sysfs (`0000:00:14.0`).

## Quick test (manual reset)

Replace `0000:00:14.0` with your ID if different:

```bash
echo 0000:00:14.0 | sudo tee /sys/bus/pci/drivers/xhci_hcd/unbind
sleep 1
echo 0000:00:14.0 | sudo tee /sys/bus/pci/drivers/xhci_hcd/bind
```

If USB/BT return, proceed with the automatic fix below.

## Permanent fix: reset xHCI automatically on resume

Create a systemd sleep hook that runs after resume.

**File**: `/usr/local/bin/resume-script.sh`
```sh
#!/bin/bash

echo 0000:00:14.0 | sudo tee /sys/bus/pci/drivers/xhci_hcd/unbind
sleep 1
echo 0000:00:14.0 | sudo tee /sys/bus/pci/drivers/xhci_hcd/bind
```
```sh
sudo chmod +x /usr/local/bin/resume-script.sh
sudo chown root:root /usr/local/bin/resume-script.sh
```

Then:

**File**: `/etc/systemd/system/resume-script.service`

```sh
[Unit]
Description=Custom script after resume from sleep
After=suspend.target hibernate.target hybrid-sleep.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/resume-script.sh
User=root
RemainAfterExit=yes

[Install]
WantedBy=suspend.target hibernate.target hybrid-sleep.target
```

## Verify

Suspend and resume:

```bash
systemctl suspend
```

After resume, USB devices and Bluetooth should work immediately.

```bash
lsusb
systemctl status bluetooth
```

# gnome as alternative (GDM to switch )

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
