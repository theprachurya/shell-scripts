#!/bin/bash

# Set keyboard layout
loadkeys us

# Set the system timezone
timedatectl set-timezone Asia/Kolkata

# Clear existing partition table and create new partitions using fdisk
(
echo o  # Create a new empty DOS partition table
echo n  # Add a new partition (swap)
echo p  # Primary partition
echo 1  # Partition number 1
echo   # First sector (press Enter to use default)
echo +4G # Size of swap partition (4GiB)
echo t  # Change partition type
echo 82 # Linux swap
echo n  # Add another partition (root)
echo p  # Primary partition
echo 2  # Partition number 2
echo   # First sector (press Enter to use default)
echo   # Press Enter to use the default last sector (to fill the rest of the disk)
echo w  # Write changes to disk
) | fdisk /dev/sda

# Format partitions
mkfs.ext4 /dev/sda2  # Format the root partition
mkswap /dev/sda1    # Set up swap partition

# Mount the root partition and enable swap
mount /dev/sda2 /mnt
swapon /dev/sda1

# Update the package database
pacman -Sy

# Install the base system, linux kernel, and firmware
pacstrap -K /mnt base linux linux-firmware

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into the new system
arch-chroot /mnt <<EOF

# Set the timezone inside the chroot environment
timedatectl set-timezone Asia/Kolkata

# Set the hardware clock
hwclock --systohc

# Generate locales
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen

# Set the hostname
echo "zen-zen" > /etc/hostname

# Regenerate initramfs
mkinitcpio -P

# Set the root password
echo "root:ninja123" | chpasswd

EOF

# Exit chroot
exit

# Inform the user to remove installation media before rebooting
echo "Installation complete. Please remove the installation media and press Enter to reboot."

# Reboot
reboot
