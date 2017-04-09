#!/bin/bash
# https://raw.githubusercontent.com/XescuGC/dotfiles/master/mount_arch.sh

confirm() {
  read -r -p "${1:-Are you sure? } [y/N]" response
  case "$response" in
    [yY][eE][sS]|[yY]) 
      true
      ;;
    *)
      false
      ;;
  esac
}

choose() {
  read -r -p "${1} " response
  echo $response
}

confirm "Setting keymap to ES" && \
  loadkeys /usr/share/kbd/keymaps/i386/qwerty/es.map.gz

confirm "Setting timezone to Europe/Madrid" && \
  timedatectl set-ntp true && \
  timedatectl set-timezone Europe/Madrid

fdisk -l && free -m
disk=$(choose "Which disk do you want to partitionate? ")
mem=$(choose "How many memory (in GiB)? (the rest to swap)")

parted $disk mklabel msdos
parted $disk mkpart primary ext4 0% ${mem}GiB
parted $disk set 1 boot on
parted $disk mkpart primary linux-swap ${mem}GiB 100%
parted $disk print

echo "Formatting the partittion"

mkfs.ext4 ${disk}1
mkswap ${disk}2
swapon ${disk}2

echo "Mounting the FS"

mount $disk /mnt

echo "Install the base packages"

pacstrap /mnt base base-devel

echo "Configure the System"

echo "Fstab"

genfstab -U /mnt >> /mnt/etc/fstab

echo "Chroot"

arch-chroot /mnt

echo "Timezone"

ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc --utc

echo "Hostname"

hostname=$(choose "Which is the hostname? ")
echo $hostname > /etc/hostname

echo "Boot loader"

pacman -S grub os-prober
grub-install --recheck --target=i386-pc $disk
grub-mkconfig -o /boot/grub/grub.cfg

echo "Root Pass"

passwd

echo "
  To configure the Locale
  > vi /etc/locale.gen

  Search for 'en_US.UTF-8' and uncomment this one and the others similars.

  > locale-gen
  > echo LANG=en_US.UTF-8 > /etc/locale.conf
  > export LANG=en_US.UTF-8
  > echo KEYMAP=/usr/shared/kbd/keymaps/i386/qwerty/es.map.gz > /etc/vconsole.conf
  > export KEYMAP=/usr/shared/kbd/keymaps/i386/qwerty/es.map.gz

  To finish

  > unmount -R /mnt
  > reboot
"

echo "You have finish"



