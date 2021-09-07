#!/bin/bash
# https://raw.githubusercontent.com/xescugc/dotfiles/master/arch/mount_arch.sh

set -e

confirm() {
  read -r -p "${1:-Are you sure? } [y/N]" response
  case "$response" in
    [yY][eE][sS]|[yY])
      true
      ;;
    *)
      echo "escaped"
      false
      ;;
  esac
}

choose() {
  read -r -p "${1} " response
  echo $response
}

printTitle() {
  echo "############## $1"
  echo ""
}

confirm "Setting timezone to Europe/Madrid" && \
  timedatectl set-ntp true && \
  timedatectl set-timezone Europe/Madrid

fdisk -l && free -m
disk=$(choose "Which disk do you want to partitionate? (Ex: /dev/nvme0n1) ")
mem=$(choose "How many memory (in GiB) the rest to swap? (Ex: 400) ")

parted $disk mklabel msdos
parted $disk mkpart primary ext4 0% ${mem}GiB
parted $disk set 1 boot on
parted $disk mkpart primary linux-swap ${mem}GiB 100%
parted $disk print

printTitle "Formatting the partition"

mkfs.ext4 ${disk}p1
mkswap ${disk}p2
swapon ${disk}p2

printTitle "Mounting the FS"

mount ${disk}p1 /mnt

printTitle "Sort and update the mirrors"

curl https://www.askapache.com/s/u.askapache.com/2013/05/reflector.txt > reflector.sh
bash reflector.sh | sudo tee /etc/pacman.d/mirrorlist

printTitle "Install the base packages"

pacstrap /mnt base base-devel

printTitle "Configure the System"

printTitle "Fstab"

genfstab -U /mnt >> /mnt/etc/fstab

printTitle "Getting config_mnt"

curl https://raw.githubusercontent.com/xescugc/dotfiles/master/arch/config_mnt.sh > /mnt/config_mnt.sh

printTitle "Chroot"

arch-chroot /mnt

printTitle "Unmounting /mnt"

umount -R /mnt

echo "You have finished, now 'reboot' or 'shutdown now'"
