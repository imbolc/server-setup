#!/bin/sh
set -eu

printf 'essential tools ... '

sudo apt-get -qqq update

sudo apt-get install -qqqy \
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

printf '\033[0;32mok\033[0m\n'
