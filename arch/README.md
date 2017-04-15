# Intallation of Arch linux

---

# Part 1

## Set keyboard

`loadkeys /usr/shared/kbd/keymaps/i386/qwerty/es.map.gz`

## Set Timezone

`timedatectl set-ntp true`
`timedatectl set-timezone Europe/Madrid`

## Partition the disks

```
$> fdisk -l
$> parted /dev/sda
(parted) mklable msdos
(parted) mkpart primary ext4 0% 7GiB
(parted) set 1 boot on
(parted) mkpart primary linux-swap 7GiB 100%
(parted) print
```

## Format the partition

`$> mkfs.ext4 /dev/sda1`
`$> mkswap /dev/sda2`
`$> swapon /dev/sda2`

## Mounting the file systems

`$> mount /dev/sda1 /mnt`

## Install the base packages

`$> pacstrap /mnt base base-devel

## Configure de system

### Fstab

`$> genfstab -U /mnt >> /mnt/etc/fstab`

### Chroot

`$> arch-chroot /mnt`

### Timezone

`#> ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
`#> hwclock --systohc --utc`

### Locale

`#> vi /etc/locale.gen`

Search for `en_US.UTF-8` and uncomment this one and the others similars.

`#> locale-gen`
`#> echo LANG=en_US.UTF-8 > /etc/locale.conf`
`#> export LANG=en_US.UTF-8`
`#> echo KEYMAP=/usr/shared/kbd/keymaps/i386/qwerty/es.map.gz > /etc/vconsole.conf`
`#> export KEYMAP=/usr/shared/kbd/keymaps/i386/qwerty/es.map.gz`

### Hostname

`#> echo yuno > /etc/hostname`

### Netework

wireless?

### Boot loader

`#> pacman -S grub os-prober`
`#> grub-install --recheck --target=i386-pc /dev/sda`
`#> grub-mkconfig -o /boot/grub/grub.cfg`

### Root Pass

`#> passwd`

## Reboot

`$> umount -R /mnt`
`$> reboot`

# Part 2

## Set up ethernet connection

`$> systemctl start dhcpcd@enp0s3`
`$> systemctl enable dhcpcd@enp0s3`

## Create users

`$> useradd -m -g users -s /bin/bash xescugc`
`$> passwd xescugc`

## Sudo

`$> pacman -S sudo`

Search for `root` and copy the line and change `root` for the user

`$> vi /etc/sudoers`

Exit and login to the new user, to test if it works run on the new user

`$> sudo pacman -Sy`

## YAOURT

`$> pacman -S git`
`$> git clone https://aur.archlinux.org/package-query`
`$> cd package-query`
`$> makepkg -si`
`$> cd`
`$> git clone https://aur.archlinux.org/yaourt.git`
`$> cd yaourt`
`$> mkconfig -si`

## i3

`$> pacman -S i3 dmenu xorg xorg-xinit`i3status

## rxvt-unicode

`$> pacman -S rxvt-unicode`

# .xinitrc

```
#! /bin/bash
setxkbmap es
exec i3
```


# Font

`$> yaourt -S ttf-roboto-mono`

# i3lock

`$> pacman -S i3loc`

Configuration on the i3 config

# rofi

`$> pacman -S rofi`

# Other

openssh

# Links

* [Language Toggle](http://docs.slackware.com/howtos:window_managers:keyboard_layout_in_i3)

