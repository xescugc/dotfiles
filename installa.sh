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
    gpicview-gtk3 pcmanfm-gtk3 dunst pulseaudio pavucontrol \
    bluez bluez-utils pulseaudio-bluetooth

  yaourt -S gohufont xbanish
fi

if confirm "Create symlinks for the configuration?"
then
  ln -svi -T $HOME/dotfiles/git/.gitconfig $HOME/.gitconfig
  ln -svi -T $HOME/dotfiles/X/.Xdefaults $HOME/.Xdefaults
  ln -svi -T $HOME/dotfiles/X/.xinitrc $HOME/.xinitrc
  ln -svi -T $HOME/dotfiles/system/.bashrc $HOME/.bashrc
  ln -svi -T $HOME/dotfiles/system/.bash_profile $HOME/.bash_profile
  ln -svi -T $HOME/dotfiles/i3/config $HOME/.config/i3/config
  ln -svi -T $HOME/dotfiles/i3status/config $HOME/.config/i3status/config
  ln -svi -T $HOME/dotfiles/rofi/config $HOME/.config/rofi/config
  ln -svi -T $HOME/dotfiles/.vimperatorrc $HOME/.vimperatorrc
  ln -svi -T $HOME/dotfiles/tmux/.tmux.conf $HOME/.tmux.conf
  ln -svi -T $HOME/dotfiles/dunst/dunstrc $HOME/.config/dunst/dunstrc
  ln -svi -T $HOME/dotfiles/re.pl/repl.rc $HOME/.re.pl/repl.rc
  ln -svi $HOME/dotfiles/vim $HOME/.vim
fi

if confirm "Install Vim Plugins? (with Vundle)"
then
  vim +PluginInstall +qall
fi
