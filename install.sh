#!/bin/sh

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

error() {
  echo "\033[31mError: $@\033[m" >&2
}

setup_colors() {
  # Only use colors if connected to a terminal
  if [ -t 1 ]; then
    RED=$(printf '\033[31m')
    GREEN=$(printf '\033[32m')
    YELLOW=$(printf '\033[33m')
    BLUE=$(printf '\033[34m')
    BOLD=$(printf '\033[1m')
    RESET=$(printf '\033[m')
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    RESET=""
  fi
}

install_package() {
  if command_exists "apt"; then
    apt install "$@"
  elif command_exists "pacman"; then
    pacman -S "$@"
  else
    error "'apt' or 'pacman' is not installed"
    exit 1
  fi
}

run_remoute_script() {
  if command_exists "curl"; then
    curl -o- "$@" | bash
  else
    error "'curl' is not installed"
    exit 1
  fi
}

download_file() {
  if command_exists "curl"; then
    curl --compressed -q "$@"
  else
    error "'curl' is not installed"
    exit 1
  fi
}
error "TEST"
exit 0
setup_colors
install_package "git"
install_package "zsh"

# Install Oh My ZSH
run_remoute_script "https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh"

# Install NVM
run_remoute_script "https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh"
install_package "yarn --no-install-recommends"

install_package "htop"

# Install ranger
install_package "ranger"
echo "set show_hidden true" >> "$HOME/.config/ranger/rc.conf"


#download_file -s https://github.com/serhiichuk/linux-configs/tree/master/vpn -o ~/Downloads/test
