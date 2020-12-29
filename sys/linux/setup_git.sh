#!/bin/bash

source ./helpers.sh

# Setting up git configurations
echo "Configuring git..."

git config --global user.email "yizhang82@outlook.com"
git config --global user.name "Yi Zhang"
git config --global core.excludesfile '~/.gitignore_global'
git config --global diff.tool 'vimdiff'
echo "__build" >> ~/.gitignore_global

# Setting up git credentials
echo "Setting up git credentials..."

if [[ -n "$WSLENV" ]]; then
  # Use git-credential-manager.exe from Git for Windows
  echo "Setting up git-credential-manager for WSL..."
  git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager.exe"
elif [ -x "$(command -v dnf)" ]; then
  # Fedora
  echo "Fedora: Setting up libsecret..."
  install_pkg git-credential-libsecret
elif [ -x "$(command -v apt-get)" ]; then
  # Ubuntu/Debian
  echo "Ubuntu/Debian: Setting up libsecret..."
  sudo apt-get install libsecret-1-0 libsecret-1-dev
  pushd /usr/share/doc/git/contrib/credential/libsecret
  sudo make
  git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
  popd
else
  echo "Unknown distro - not supported"
  exit -1
fi
