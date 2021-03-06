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
install_pkg mosh

# Libraries
echo "========================================"
echo "Installing development libraries"
echo "========================================"
install_pkg libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev libzstd-dev libreadline-dev
install_pkg libsqlite3-dev
install_pkg libssl-dev openssl-devel
install_pkg libncurses5-dev ncurses-devel
install_pkg libtirpc-devel
install_pkg rpcgen
install_pkg flex bison
install_pkg libcap-dev

# Languages
echo "========================================"
echo "Installing languages..."
echo "========================================"
install_pkg golang rustc cargo python
install_pkg ruby-dev ruby-devel

# Utilities
echo "========================================"
echo "Installing utilities..."
echo "========================================"
install_pkg curl silversearcher-ag pkg-config
install_pkg sysstat
install_pkg linux-tools-$(uname -r) linux-cloud-tools-$(uname -r)

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
