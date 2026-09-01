#!/bin/sh
set -eu

printf 'git ... '

sudo apt-get -qqq update
sudo apt-get install -qqqy git

git config --global alias.ci commit
git config --global alias.st status
git config --global alias.co checkout

printf '\033[0;32mok\033[0m\n'
