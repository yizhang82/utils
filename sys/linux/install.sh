#!/bin/bash

# Initialize
source ./helpers.sh

# Ensure package manager database is up-to-date
echo "========================================"
echo "Updating database..."
echo "========================================"
check_update_pkg

# System
echo "========================================"
echo "Installing system utilities..."
echo "========================================"
install_pkg sysstat
if [[ -z "$WSLENV" ]]; then
  # Only install following for native linux (not WSL)
  install_pkg tlp
  install_pkg powerstat
  install_pkg qemu
fi

# Developer Tools
echo "========================================"
echo "Installing developer utilities"
echo "========================================"

install_pkg make autoconf cmake lldb bison
install_pkg gcc clang gdb lldb

# Libraries
echo "========================================"
echo "Installing developer utilities"
echo "========================================"
install_pkg libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev libssl-dev libzstd-dev libncurses5-dev libreadline-dev
install_pkg libsqlite3-dev

# Languages
echo "========================================"
echo "Installing languages..."
echo "========================================"
install_pkg golang rustc cargo python

# Utilities
echo "========================================"
echo "Installing utilities..."
echo "========================================"
install_pkg curl silversearcher-ag pkg-config

# Docker
echo "========================================"
echo "Installing Docker..."
echo "========================================"
if [ "$PKG_TYPE" == "apt" ]; then
  sudo apt -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
  echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" | sudo tee /etc/apt/sources.list.d/docker.list
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io -y
fi
