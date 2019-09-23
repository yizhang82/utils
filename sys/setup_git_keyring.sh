#!/bin/sh
sudo apt-get install libgnome-keyring-dev
cd /usr/share/doc/git/contrib/credential/gnome-keyring
sudo make
sudo git config --system credential.helper /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring
