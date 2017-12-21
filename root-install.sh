#!/bin/bash

apt-get install -y aptitude
aptitude update
aptitude upgrade -y


echo "=== INSTALL PACKAGES"
# core
aptitude install -y sudo tmux curl htop cron mc ranger mosh wrk rsync

# web
aptitude install -y nginx supervisor

# build
aptitude install -y gcc build-essential

# python extensions
aptitude install -y libssl-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev zlib1g-dev tk-dev

# build PIL from source
aptitude install -y libjpeg-dev libfreetype6-dev

# pyaml speedup
apt install -y libyaml-dev

# base python
aptitude install -y python python-setuptools python-dev


echo "=== LOCALES"
aptitude install -y locales 
echo "LANG=en_US.UTF-8" > /etc/default/locale
cat > /etc/locale.gen << EOF
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
EOF
locale-gen


echo "=== GIT"
aptitude install -y git-core
git config --global core.editor "vim"
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.co checkout


echo "=== VIM"
aptitude purge -y vim
aptitude install -y neovim python-pip python-dev python3-dev python3-venv

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
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
sudo aptitude install -y nodejs
