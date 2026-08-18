#!/usr/bin/env bash

apt update && apt upgrade -y
apt install -y sudo

read -p "Enter a username for sudo user: " -i user -e SUDO_USER
adduser --gecos "" $SUDO_USER
adduser $SUDO_USER sudo
echo "$SUDO_USER ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/$SUDO_USER

_AUTH_KEYS_FILENAME=/home/$SUDO_USER/.ssh/authorized_keys
echo
echo We\'re going to disable password-based authentication.
echo To copy public key from your local computer run: ssh-copy-id $SUDO_USER@your_server_ip
while true; do
    if [ -s $_AUTH_KEYS_FILENAME ]; then
        break
    fi
    echo
    read -n 1 -r -s -p "There's nothing in $_AUTH_KEYS_FILENAME at the moment. Press any key when it's ready..."
done
echo

echo "=== tools"
apt install -y \
    curl \
    git \
    htop \
    mc \
    mosh \
    ncdu \
    rsync \
    tmux \
    tree \
    wget

echo "=== Update .bashrc"
cat >>~/.bashrc <<EOF

# vim-like comand line
set -o vi

# vim as default editor
export VISUAL=vim
export EDITOR="$VISUAL"
EOF

echo "=== LOCALES"
apt install -y locales
echo "LANG=en_US.UTF-8" >/etc/default/locale
cat >/etc/locale.gen <<EOF
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
apt install -y neovim

echo "=== .inputrc"
cat >>~/.inputrc <<EOF
set editing-mode vi
EOF

echo === Setting up $SUDO_USER
runuser -l $SUDO_USER -c 'cd && wget --no-check-certificate https://raw.github.com/imbolc/server-setup/master/bookworm/user-install.sh && bash user-install.sh'

echo === Restricting SSH authentication
cat >/etc/ssh/sshd_config <<EOF
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
