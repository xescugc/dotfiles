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

archChroot() {
  command arch-chroot /mnt $@
}

confirm "Setting timezone to Europe/Madrid" && \
  timedatectl set-ntp true && \
  timedatectl set-timezone Europe/Madrid

fdisk -l && free -m
disk=$(choose "Which disk do you want to partitionate? (Ex: nvme0n1) ")
mem=$(choose "How many memory (in GiB) the rest to swap? (Ex: 400) ")

parted $disk mklabel msdos
parted $disk mkpart primary ext4 0% ${mem}GiB
parted $disk set 1 boot on
parted $disk mkpart primary linux-swap ${mem}GiB 100%
parted $disk print

printTitle "Formatting the partittion"

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

printTitle "Chroot"

printTitle "Timezone"

archChroot ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
archChroot hwclock --systohc --utc

printTitle "Hostname"

hostname=$(choose "Which is the hostname? ")
archChroot echo $hostname > /etc/hostname

printTitle "Boot loader"

archChroot pacman -S grub os-prober
archChroot grub-install --recheck --target=i386-pc $disk
archChroot grub-mkconfig -o /boot/grub/grub.cfg

printTitle "Root Pass"

archChroot passwd

archChroot echo "
en_US.UTF-8 UTF-8
en_US ISO-8859-1
" > /etc/locale.gen

printTitle "Configuring Locale"

archChroot locale-gen
archChroot echo LANG=en_US.UTF-8 > /etc/locale.conf
archChroot export LANG=en_US.UTF-8
archChroot echo KEYMAP=/usr/shared/kbd/keymaps/i386/qwerty/es.map.gz > /etc/vconsole.conf
archChroot export KEYMAP=/usr/shared/kbd/keymaps/i386/qwerty/es.map.gz

umount -R /mnt
reboot

echo "You have finished"
