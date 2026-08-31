#!/bin/sh
set -eu

: "${SUDO_USER:?Set SUDO_USER to the user to create}"
: "${AUTHORIZED_KEY:?Set AUTHORIZED_KEY to the public key for SUDO_USER}"

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

apt-get update
apt-get -y -o Dpkg::Options::=--force-confold upgrade
apt-get -y -o Dpkg::Options::=--force-confold install sudo

adduser --disabled-password --gecos "" "$SUDO_USER"
usermod -aG sudo "$SUDO_USER"

USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
install -d -m 700 -o "$SUDO_USER" -g "$SUDO_USER" "$USER_HOME/.ssh"
AUTHORIZED_KEYS_PATH=$USER_HOME/.ssh/authorized_keys
install -m 600 -o "$SUDO_USER" -g "$SUDO_USER" /dev/null "$AUTHORIZED_KEYS_PATH"
printf '%s\n' "$AUTHORIZED_KEY" >"$AUTHORIZED_KEYS_PATH"

SUDOERS_FILE=/etc/sudoers.d/$SUDO_USER
printf '%s ALL=(ALL) NOPASSWD: ALL\n' "$SUDO_USER" >"$SUDOERS_FILE"
chmod 440 "$SUDOERS_FILE"
visudo -cf "$SUDOERS_FILE"

echo "=== tools"
apt-get -y -o Dpkg::Options::=--force-confold install \
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
cat >>~/.bashrc <<'EOF'

# vim-like command line
set -o vi

# vim as default editor
export VISUAL=vim
export EDITOR="$VISUAL"
EOF

echo "=== LOCALES"
apt-get -y -o Dpkg::Options::=--force-confold install locales
echo "LANG=en_DK.UTF-8" >/etc/default/locale
cat >/etc/locale.gen <<'EOF'
en_DK.UTF-8 UTF-8
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
apt-get -y -o Dpkg::Options::=--force-confold install neovim

echo "=== .inputrc"
cat >>~/.inputrc <<'EOF'
set editing-mode vi
EOF

echo "=== Setting up $SUDO_USER"
runuser -l "$SUDO_USER" -c 'cd && wget --no-check-certificate -O user-install.sh https://raw.github.com/imbolc/server-setup/master/bookworm/user-install.sh && sh user-install.sh'

echo "=== Restricting SSH authentication"
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
/usr/sbin/sshd -t
systemctl restart sshd.service

echo
echo "Everything is done, congrats :)"
echo "Now only $SUDO_USER is allowed to access the server by ssh with only public key authorization option"
echo "Check that you can log-in before closing this connection: ssh $SUDO_USER@your_server_ip"
