#!/usr/bin/env bash
set -euo pipefail

echo -en "git ... "

sudo apt -qqq update
sudo apt install -qqqy git

git config --global core.editor "vim"
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.co checkout

echo -e "\033[0;32mok\033[0m"
