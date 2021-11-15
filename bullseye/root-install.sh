#!/usr/bin/env bash

apt update && apt upgrade -y
apt install -y sudo

read -p "Enter a username for sudo user: " -i user -e SUDO_USER
adduser --gecos "" $SUDO_USER
adduser $SUDO_USER sudo
echo "$SUDO_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$SUDO_USER

_AUTH_KEYS_FILENAME=/home/$SUDO_USER/.ssh/authorized_keys
echo
echo We\'re going to disable password-based authentication.
echo To copy public key from your local computer run: ssh-copy-id $SUDO_USER@your_server_ip
while true; do
    if [ -s $_AUTH_KEYS_FILENAME ]; then
        break;
    fi
    echo
    read -n 1 -r -s -p "There's nothing in $_AUTH_KEYS_FILENAME at the moment. Press any key when it's ready..."
done
echo

echo "=== tools"
apt install -y \
  build-essential \
  cron \
  curl \
  gcc \
  git \
  htop \
  mc \
  mosh \
  ncdu \
  nginx \
  nodejs \
  npm \
  ntp \
  ranger \
  rsync \
  tmux \
  tree \
  wget \
  wrk \
  xz-utils


echo "=== python"
apt install -y \
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-venv

echo "=== python speedups"
apt install -y \
    libssl-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libffi-dev \
    zlib1g-dev \
    libncurses5-dev \
    libxml2-dev \
    libxmlsec1-dev
    libjpeg-dev \
    libfreetype6-dev \
    libyaml-dev

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
git config --global core.editor "vim"
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.co checkout


echo "=== VIM"
apt purge -y vim
apt install -y fuse python3-neovim

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod +x nvim.appimage
mv nvim.appimage /usr/local/bin/vim

rm -R ~/.vim ~/.vimrc
git clone https://github.com/imbolc/.vim ~/.vim
mkdir ~/.config
ln -s ~/.vim ~/.config/nvim
vim +PlugInstall +qall

cd ~/.vim
python3 -m venv py3env
./py3env/bin/pip install wheel
./py3env/bin/pip install -r requirements.txt

update-alternatives --install /usr/bin/vim vim /usr/local/bin/vim 60
update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 60


echo "=== .inputrc"
cat >> ~/.inputrc << EOF
set editing-mode vi
EOF


echo === Setting up $SUDO_USER
runuser -l $SUDO_USER -c 'cd && wget --no-check-certificate https://raw.github.com/imbolc/server-setup/master/bullseye/user-install.sh && bash user-install.sh'


echo === Restricting SSH authentication
cat > /etc/ssh/sshd_config << EOF
# disable password-based authentication
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM no

# disable root login
PermitRootLogin no

# only allow ssh connections from only these users
AllowUsers $SUDO_USER
EOF
systemctl restart sshd.service

echo
echo "Everything is done, congrats :)"
echo "Now only $SUDO_USER is alowed to access the server by ssh with only public key authorization option"
echo "Check that you can log-in before closing this connection: ssh $SUDO_USER@your_server_ip"
