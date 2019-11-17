#!/bin/bash

apt update
apt upgrade -y


echo "=== INSTALL PACKAGES"
# core
apt install -y sudo tmux curl htop cron mc ranger mosh wrk rsync ntp

# web
apt install -y nginx supervisor

# build
apt install -y gcc build-essential

# python extensions
apt install -y libssl-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev zlib1g-dev tk-dev libncurses5-dev libxml2-dev libxmlsec1-dev

# build PIL from source
apt install -y libjpeg-dev libfreetype6-dev

# pyaml speedup
apt install -y libyaml-dev

# base python
apt install -y python python-setuptools python-dev

echo "=== Update .bashrc"
cat >> ~/.bashrc << EOF

# vim-like comand line
set -o vi

# vim as default editor
export VISUAL=vim
export EDITOR="$VISUAL"
EOF


echo "=== LOCALES"
apt install -y locales 
echo "LANG=en_US.UTF-8" > /etc/default/locale
cat > /etc/locale.gen << EOF
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
EOF
locale-gen


echo "=== GIT"
apt install -y git-core
git config --global core.editor "vim"
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.co checkout


echo "=== VIM"
apt purge -y vim
apt install -y neovim python-pip python-dev python3-dev python3-venv

rm -R ~/.vim ~/.vimrc
git clone https://github.com/imbolc/.vim ~/.vim
mkdir ~/.config
ln -s ~/.vim ~/.config/nvim
nvim +PlugInstall +qall

cd ~/.vim
python3 -m venv py3env
./py3env/bin/pip install wheel
./py3env/bin/pip install -r requirements.txt

update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60

echo "=== NODE"
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt install -y nodejs
