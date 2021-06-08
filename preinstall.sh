#!/usr/bin/env bash
#-------------------------------------------------------------------------
#      _          _    __  __      _   _
#     /_\  _ _ __| |_ |  \/  |__ _| |_(_)__
#    / _ \| '_/ _| ' \| |\/| / _` |  _| / _|
#   /_/ \_\_| \__|_||_|_|  |_\__,_|\__|_\__|
#  Arch Linux Post Install Setup and Config
#-------------------------------------------------------------------------

echo "-------------------------------------------------"
echo "     Setting up mirrors for optimal download"
echo "-------------------------------------------------"
timedatectl set-ntp true
pacman -S --noconfirm pacman-contrib reflector
if [ -f /etc/pacman.d/mirrorlist ]; then
    mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
fi
reflector --country Germany --latest 10 --sort rate --save /etc/pacman.d/mirrorlist


echo "-------------------------------------------------"
echo "     Installing prereqs"
echo "-------------------------------------------------"
pacman -S --noconfirm gptfdisk btrfs-progs

echo "-------------------------------------------------"
echo "     Select your disk to format"
echo "-------------------------------------------------"
lsblk
echo "Please enter disk: (example /dev/sda)"
read DISK
echo "-------------------------------------------------"
echo "     Formatting disk"
echo "-------------------------------------------------"

# disk prep
sgdisk -Z ${DISK}                   # zap all on disk
sgdisk -a 2048 -o ${DISK}           # new gpt disk 2048 alignment

# create partitions
sgdisk -n 1:0:+1024M ${DISK}        # partition 1 (UEFI SYS), default start block, 512MB
sgdisk -n 2:0:0 ${DISK}             # partition 2 (Root), default start, remaining

# set partition types
sgdisk -t 1:ef00 ${DISK}
sgdisk -t 2:8300 ${DISK}

# label partitions
sgdisk -c 1:"UEFI" ${DISK}
sgdisk -c 2:"ROOT" ${DISK}

# make filesystems
echo "-------------------------------------------------"
echo "     Creating Filesystems"
echo "-------------------------------------------------"

mkfs.fat -F32 -n "UEFI" "${DISK}1"
mkfs.ext4 -L "ROOT" "${DISK}2"

# mount target
mkdir /mnt
mount -t ext4 "${DISK}2" /mnt
mkdir /mnt/boot
#mkdir /mnt/boot/efi
mount -t vfat "${DISK}1" /mnt/boot/

echo "-------------------------------------------------"
echo "     Arch Install on Main Drive"
echo "-------------------------------------------------"
pacstrap /mnt base base-devel linux linux-firmware nano --noconfirm --needed
genfstab -U /mnt >> /mnt/etc/fstab

# copy to new script to run in arch-root
cp preinstall-root.sh /mnt/preinstall-root.sh
chmod a+x /mnt/preinstall-root.sh

echo "-------------------------------------------------"
echo "     Switching root"
echo "-------------------------------------------------"
sleep 10
arch-chroot /mnt ./preinstall-root.sh ${DISK}2

umount -R /mnt

echo "-------------------------------------------------"
echo "     SYSTEM READY FOR FIRST BOOT"
echo "-------------------------------------------------"