#!/bin/bash
# https://raw.githubusercontent.com/xescugc/dotfiles/master/arch/mount_arch.sh

set -e

GREEN='\033[0;32m'
NC='\033[0m' # No Color

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
  read -r -p "${1}" response
  echo $response
}

printTitle() {
  echo -e "${GREEN} ############## $1 ${NC}"
  echo ""
}

archChroot() {
  command arch-chroot /mnt "$@"
}

confirm "Setting timezone to Europe/Madrid" && \
  timedatectl set-ntp true && \
  timedatectl set-timezone Europe/Madrid

printTitle "Formatting the partition"

fdisk -l && free -m
disk=$(choose "Which disk do you want to partitionate? (Ex: /dev/nvme0n1) ")
mem=$(choose "How many memory (in GiB) the rest to swap and 261MiB to EFI? (Ex: 400) ")

parted $disk mklabel gpt
parted $disk mkpart "efi" fat32 0% 261MiB
#parted $disk mkpart primary ext4 0% ${mem}GiB
parted $disk set 1 esp on
parted $disk mkpart "root" ext4 261MiB ${mem}GiB
parted $disk mkpart "swap" linux-swap ${mem}GiB 100%
parted $disk print

mkfs.fat -F32 ${disk}p1
mkfs.ext4 ${disk}p2
mkswap ${disk}p3
swapon ${disk}p3

printTitle "Mounting the FS"

mount ${disk}p2 /mnt

printTitle "Sort and update the mirrors"

pacman -Syy
pacman -S --noconfirm reflector 
reflector -c "ES" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

printTitle "Install the base packages"

pacstrap /mnt base linux linux-firmware base-devel

printTitle "Configure the System"

printTitle "Fstab"

genfstab -U /mnt >> /mnt/etc/fstab

printTitle "Chroot"

printTitle "Timezone"

archChroot ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
archChroot hwclock --systohc --utc

printTitle "Hostname"

hostname=$(choose "Which is the hostname? ")
archChroot sh -c "echo $hostname > /etc/hostname"

printTitle "Boot loader"

archChroot pacman --noconfirm -S grub efibootmgr

archChroot mkdir /boot/efi
archChroot mount ${disk}p1 /boot/efi
archChroot grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
archChroot grub-mkconfig -o /boot/grub/grub.cfg

printTitle "Root Pass"

archChroot passwd

archChroot echo "
en_US.UTF-8 UTF-8
en_US ISO-8859-1
" > /etc/locale.gen

printTitle "Configuring Locale"

archChroot locale-gen
archChroot sh -c "echo LANG=en_US.UTF-8 > /etc/locale.conf"
archChroot sh -c "echo KEYMAP=/usr/shared/kbd/keymaps/i386/qwerty/es.map.gz > /etc/vconsole.conf"

printTitle "Creating user"

username=$(choose "Which is the username? ")

archChroot useradd -m -g users -s /bin/bash $username
archChroot passwd $username

archChroot pacman --noconfirm -S sudo
archChroot sh -c "echo \"
## Autogenerated from installation
$username ALL=(ALL) ALL
\" >> /etc/sudoers"

printTitle "Clonning dotfiles"

archChroot pacman --noconfirm -S git
archChroot git clone https://github.com/xescugc/dotfiles.git /home/${username}/dotfiles

printTitle "Unmounting /mnt"

umount -R /mnt

echo "You have finished, now 'reboot' or 'shutdown now'"
