#!/usr/bin/env bash

if ! grep -Fxq 'PasswordAuthentication yes' /etc/ssh/sshd_config
then
    echo 'Password authentication should be enabled'
    echo 'Put `PasswordAuthentication yes` into your `/etc/ssh/sshd_config`'
    echo 'And restart ssh service with `systemctl restart sshd.service`'
    exit 1
fi
echo continue

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

echo "=== CLEANUP"
sudo apt autoremove --purge -y snapd unattended-upgrades
sudo rm -rf /var/cache/snapd/
sudo rm -rf /var/log/unattended-upgrades

echo "=== UPGRADE"
apt update
apt install -y dialog
apt upgrade -y

echo "=== INSTALL PACKAGES"
# core
apt install -y sudo apt-utils tmux curl htop cron mc ranger mosh rsync ntp git

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
apt install -y python3 python3-setuptools python3-dev python3-pip

echo "=== Open mosh ports"
crontab -l | { cat; echo "@reboot /usr/sbin/iptables -I INPUT 1 -p udp --dport 60000:61000 -j ACCEPT"; } | crontab -

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
runuser -l $SUDO_USER -c 'cd && wget --no-check-certificate https://raw.github.com/imbolc/server-setup/master/focal/user-install.sh && bash user-install.sh'


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
