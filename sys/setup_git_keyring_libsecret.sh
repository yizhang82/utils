#!/bin/sh
git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
cd /usr/share/doc/git/contrib/credential/libsecret
sudo make
git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
