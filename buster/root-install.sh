#!/usr/bin/env bash

read -p "Enter a username for sudo user: " -i user -e SUDO_USER
adduser $SUDO_USER
adduser $SUDO_USER sudo
echo "$SUDO_USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$SUDO_USER > /dev/null
/etc/init.d/sudo restart


apt update && apt upgrade -y

echo "=== INSTALL PACKAGES"
# core
apt install -y sudo tmux curl htop cron mc ranger mosh rsync ntp

# web
apt install -y nginx

# build
apt install -y gcc build-essential

# python extensions
apt install -y libssl-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev zlib1g-dev tk-dev libncurses5-dev libxml2-dev libxmlsec1-dev

# build pillow from source
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
/usr/sbin/locale-gen


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


echo "=== .inputrc"
cat >> ~/.inputrc << EOF
set editing-mode vi
EOF


echo === Setting up $SUDO_USER
runuser -l imbolc -c 'cd && wget --no-check-certificate https://raw.github.com/imbolc/server-setup/master/buster/user-install.sh && bash user-install.sh'
