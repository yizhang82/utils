#!/bin/bash

# System
if [[ -z "$WSLENV" ]]; then
  # Only install following for native linux (not WSL)
  sudo apt install tlp powerstat -y
  sudo apt install qemu -y
fi

# Developer Tools
sudo apt install make -y
sudo apt install autoconf cmake lldb bison -y
sudo apt install clang -y

# Libraries
sudo apt install libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev libssl-dev libzstd-dev libncurses5-dev libreadline-dev -y
sudo apt install libsqlite3-dev -y

# Languages
sudo apt install golang rustc python -y

# Utilities
sudo apt install curl silversearcher-ag pkg-config -y

# Docker
sudo apt -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io -y
