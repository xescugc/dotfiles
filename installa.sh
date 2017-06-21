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

if confirm "Installing needed packages?"
then
  sudo pacman -S i3 xorg xorg-xinit i3status rofi rxvt-unicode i3lock \
    openssh ranger vim arandr wget openvpn bash-completion \
    gpicview pcmanfm dunst pulseaudio pavucontrol \
    bluez bluez-utils pulseaudio-bluetooth \
    vagrant ansible virtualbox nfs-utils \
    unzip playerctl \
    galculator chromium thunderbird \
    firefox go xf86-video-intel

  yaourt -S gohufont xbanish clipit rambox-bin
  # It may fail for the perl XML::Parser missing
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
  mkdir -p $HOME/.config/rofi && ln -svi -T $HOME/dotfiles/rofi/config $HOME/.config/rofi/config
  mkdir -p $HOME/.re.pl && ln -svi -T $HOME/dotfiles/re.pl/repl.rc $HOME/.re.pl/repl.rc
  ln -svi -T $HOME/dotfiles/.vimperatorrc $HOME/.vimperatorrc
  ln -svi -T $HOME/dotfiles/tmux/.tmux.conf $HOME/.tmux.conf
  ln -svi $HOME/dotfiles/.vim $HOME
  ln -svi $HOME/dotfiles/.bin $HOME
fi

if confirm "Install Vim Plugins? (with Vundle)"
then
  vim +PluginInstall +qall
fi
