#!/bin/bash
# https://raw.githubusercontent.com/xescugc/dotfiles/master/arch/config_mnt.sh

set -e

printTitle() {
  echo "############## $1"
  echo ""
}

choose() {
  read -r -p "${1} " response
  echo $response
}

printTitle "Timezone"

ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc --utc

printTitle "Hostname"

hostname=$(choose "Which is the hostname? ")
echo $hostname > /etc/hostname

printTitle "Boot loader"

lsblk -d
disk=$(choose "Which disk? (Ex: /dev/nvme0n1) ")
pacman -S grub os-prober
echo "GRUB_DISABLE_OS_PROBER=false" > /etc/default/grub
grub-install --recheck --target=i386-pc $disk
grub-mkconfig -o /boot/grub/grub.cfg

printTitle "Root Pass"

passwd

echo "
en_US.UTF-8 UTF-8
en_US ISO-8859-1
" > /etc/locale.gen

printTitle "Configuring Locale"

locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo KEYMAP=/usr/shared/kbd/keymaps/i386/qwerty/es.map.gz > /etc/vconsole.conf

printTitle "Creating user"

useradd -m -g users -s /bin/bash xescugc
passwd xescugc

pacman -S sudo
echo "
## Autogenerated from installation
xescugc ALL=(ALL) ALL
" >> /etc/sudoers
