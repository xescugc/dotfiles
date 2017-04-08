#!/bin/bash

confirm() {
  read -r -p "${1:-Are you sure? [y/N]} " response
  case "$response" in
    [yY][eE][sS]|[yY]) 
      true
      ;;
    *)
      false
      ;;
  esac
}

confirm "Setting keymap to ES" && \
  loadkeys /usr/shared/kbd/keymaps/i386/qwerty/es.map.gz

confirm "Setting timezone to Europe/Madrid" && \
  timedatectl set-ntp true && \
  timedatectl set-timezone Europe/Madrid
