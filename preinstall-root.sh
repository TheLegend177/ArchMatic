#!/usr/bin/env bash

echo "-------------------------------------------------"
echo "     Setup Language and set locale"
echo "-------------------------------------------------"
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
sed -i 's/^#de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
timedatectl --no-ask-password set-timezone Europe/Berlin
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="de_DE.UTF-8" LC_COLLATE="de_DE.UTF-8" LC_TIME="de_DE.UTF-8"
localectl --no-ask-password set-keymap de

echo "-------------------------------------------------"
echo "     Select a hostname for this machine"
echo "-------------------------------------------------"
read -p "Please enter hostname:" hostname

echo $hostname >> /etc/hostname

cat <<EOF >> /etc/hosts
127.0.0.1       localhost
::1             localhost
127.0.0.1       $hostname.local     $hostname
EOF

echo "-------------------------------------------------"
echo "     Bootloader Systemd Installation"
echo "-------------------------------------------------"
bootctl install
cat <<EOF > /boot/loader/entries/arch.conf
title Arch Linux  
linux /vmlinuz-linux  
initrd  /initramfs-linux.img  
options root="LABEL=ROOT" rw
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
passwd


echo "-------------------------------------------------"
echo "     Create User"
echo "-------------------------------------------------"
read -p "Please enter username:" username

useradd -m -G wheel -s /bin/bash $username
passwd $username

exit
