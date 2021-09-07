#!/bin/bash

confirm() {
  read -r -p "${1:-Are you sure? } [y/N] " response
  case "$response" in
    [yY][eE][sS]|[yY])
      true
      ;;
    *)
      false
      ;;
  esac
}

echo ""

if confirm "Install YAY?"
then
  sudo pacman -Syyu
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay && makepkg -si && cd -
fi

if confirm "Installing needed packages?"
then
  yay -S i3 xorg xorg-xinit i3status rofi rxvt-unicode i3lock \
    openssh vim arandr wget openvpn bash-completion \
    gpicview pcmanfm dunst pulseaudio pavucontrol \
    bluez bluez-utils pulseaudio-bluetooth \
    unzip playerctl \
    galculator chromium \
    firefox go xf86-video-intel scrot \
    openssl docker docker-compose xclip \
    tmux ack ctags net-tools transmission-gtk \
    vlc xarchiver bzr vault zip jq gvfs

  # It may fail for the perl XML::Parser missing
  yay -S gohufont xbanish clipit siji-git spotify

  cpan JSON

  # For the scrot alias on i3
  mkdir $HOME/screenshoots

  sudo gpasswd -a xescugc docker
  newgrp docker

  # Allow to run Docker commands without root
  sudo groupadd docker
  sudo usermod -aG docker $USER

  # Enable docker start when the system starts
  sudo systemctl enable docker

  # It's used on the script inside i3 config
  # when a screenshot is taken
  mkdir screenshoots
fi

if confirm "Create symlinks for the configuration?"
then
  ln -svi -T $HOME/dotfiles/git/.gitconfig $HOME/.gitconfig
  ln -svi -T $HOME/dotfiles/X/.Xdefaults $HOME/.Xdefaults
  ln -svi -T $HOME/dotfiles/X/.xinitrc $HOME/.xinitrc
  ln -svi -T $HOME/dotfiles/system/.bashrc $HOME/.bashrc
  ln -svi -T $HOME/dotfiles/system/.bash_profile $HOME/.bash_profile
  mkdir -p $HOME/.config/i3/ && ln -svi -T $HOME/dotfiles/i3/config $HOME/.config/i3/config
  mkdir -p $HOME/.config/i3status && ln -svi -T $HOME/dotfiles/i3status/config $HOME/.config/i3status/config
  mkdir -p $HOME/.config/dunst && ln -svi -T $HOME/dotfiles/dunst/dunstrc $HOME/.config/dunst/dunstrc
  mkdir -p $HOME/.config/clipit && ln -svi -T $HOME/dotfiles/clipit/clipitrc $HOME/.config/clipit/clipitrc
  mkdir -p $HOME/.config/rofi && ln -svi -T $HOME/dotfiles/rofi/config $HOME/.config/rofi/config
  mkdir -p $HOME/.re.pl && ln -svi -T $HOME/dotfiles/re.pl/repl.rc $HOME/.re.pl/repl.rc
  ln -svi -T $HOME/dotfiles/.vimperatorrc $HOME/.vimperatorrc
  ln -svi -T $HOME/dotfiles/tmux/.tmux.conf $HOME/.tmux.conf
  ln -svi $HOME/dotfiles/.vim $HOME
  ln -svi $HOME/dotfiles/.bin $HOME
fi

if confirm "Install Vim Plugins? (with Vundle)"
then
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall
  vim +GoInstallBinaries +qall
fi
