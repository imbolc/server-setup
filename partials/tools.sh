#!/usr/bin/env bash
set -euo pipefail

echo -en "essential tools ... "

sudo apt -qqq update
sudo apt -qqqy upgrade

sudo apt install -qqqy \
  curl \
  htop \
  iotop \
  mc \
  mosh \
  ncdu \
  ranger \
  rsync \
  tmux \
  tree \
  vim

echo -e "\033[0;32mok\033[0m" 
