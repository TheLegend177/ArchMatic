#!/usr/bin/env bash
echo "-------------------------------------------------"
echo "     Bootloader Systemd Installation"
echo "-------------------------------------------------"
bootctl install
cat <<EOF > /boot/loader/entries/arch.conf
title Arch Linux  
linux /vmlinuz-linux  
initrd  /initramfs-linux.img  
options root=%s2 rw
EOF

echo "-------------------------------------------------"
echo "     Network setup"
echo "-------------------------------------------------"
pacman -S networkmanager dhclient --noconfirm --needed
systemctl enable --now NetworkManager

echo "-------------------------------------------------"
echo "     Set Password for Root"
echo "-------------------------------------------------"
echo "Enter password for root user: "
passwd root

echo "-------------------------------------------------"
echo "     Setup Language to DE and set locale"
echo "-------------------------------------------------"
sed -i 's/^#de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
timedatectl --no-ask-password set-timezone Europe/Berlin
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="de_DE.UTF-8" LC_COLLATE="de_DE.UTF-8" LC_TIME="de_DE.UTF-8"

# Set keymaps
localectl --no-ask-password set-keymap de

echo "-------------------------------------------------"
echo "     Select a hostname for this machine"
echo "-------------------------------------------------"
read -p "Please enter hostname:" hostname

echo "-------------------------------------------------"
echo "     Create User"
echo "-------------------------------------------------"
read -p "Please enter username:" username

useradd -m $username
passwd $username

usermod --append --groups wheel $username

exit
umount -R /mnt

echo "-------------------------------------------------"
echo "     SYSTEM READY FOR FIRST BOOT"
echo "-------------------------------------------------"