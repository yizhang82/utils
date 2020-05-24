#!/bin/bash
# Clone interesting projects

git clone https://github.com/yizhang82/dotfiles ~/dotfiles

mkdir -p ~/github
pushd ~/github

# Personal repos
git clone https://github.com/yizhang82/utils
git clone https://github.com/yizhang82/yizhang82.github.io

# Database projects
git clone https://github.com/facebook/rocksdb
git clone https://github.com/mysql/mysql-server
git clone https://github.com/google/leveldb
git clone https://github.com/postgres/postgres

# Blockchain
git clone https://github.com/bitcoin/bitcoin

# OS
git clone https://github.com/torvalds/linux

popd
