# ArchMatic Installer Script

This was forked from Chris Titus Tech (https://github.com/ChrisTitusTech/ArchMatic)

This README contains the steps I do to install and configure a fully-functional Arch Linux installation containing a desktop environment, all the support packages (network, bluetooth, audio, printers, etc.), along with all my preferred applications and utilities. The shell scripts in this repo allow the entire process to be automated.)

---

## Setup Boot and Arch ISO on USB key

1. Download the Arch Live ISO from https://archlinux.org/download/
2. Create a bootable USB key from the ISO file, e.g. with Ventoy (https://www.ventoy.net/en/index.html)
3. Boot from the USB key.

### Arch Live ISO (Pre-Install)

After booting some necessary package have to be installed.

```bash
pacman -Syy
pacman -S wget curl git
```

This step installs arch to your hard drive. *IT WILL FORMAT THE DISK*
It also prompts you for a root password.

```bash
wget https://raw.githubusercontent.com/gramms/ArchMatic/master/preinstall.sh
sh ./preinstall.sh
reboot
```

### Arch Linux First Boot

After rebooting from your hard drive, the system can be installed. You will be prompted for at least the following things:
1. Hostname of your machine
2. Desired Username
3. Password

Login as root with the password you provided in the Pre-Install

```bash
pacman -S --noconfirm pacman-contrib curl git
git clone https://github.com/gramms/ArchMatic.git
cd ArchMatic
sh ./archmatic.sh
```

### This script installs the base system and a couple of applications. Feel free to clone this script and edit it to your needs.

---

### System Description
This runs Awesome Window Manager with the base configuration from the Material-Awesome project <https://github.com/ChrisTitusTech/material-awesome>. I made some minor tweaks to the config, but the overall experience is the same.

To boot I use `systemd` because it's minimalist, comes built-in, and since the Linux kernel has an EFI image, all we need is a way to execute it.

I also install the LTS Kernel along side the rolling one, and configure my bootloader to offer both as a choice during startup. This enables me to switch kernels in the event of a problem with the rolling one.

### Troubleshooting Arch Linux

__[Arch Linux Installation Gude](https://github.com/rickellis/Arch-Linux-Install-Guide)__

#### No Wifi

```bash
sudo wifi-menu`
```

#### Initialize Xorg:
At the terminal, run:

```bash
xinit
```