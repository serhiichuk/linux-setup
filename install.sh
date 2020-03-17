#!/bin/sh

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

error() {
  echo ${RED}"Error: $@"${RESET} >&2
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

install_packages() {
  if command_exists "apt"; then
    eval "apt install $*"
  elif command_exists "pacman"; then
    eval "pacman -S $*"
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

load_configs() {
  git clone https://github.com/serhiichuk/linux-setup.git
  cp -r -n /linux-setup/user/.* ~
  rm -rf ./linux-setup
}

setup_colors

install_packages "git zsh htop ranger yarn"

# Install Oh My ZSH
run_remoute_script "https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh"
# Install NVM
run_remoute_script "https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh"

load_configs
