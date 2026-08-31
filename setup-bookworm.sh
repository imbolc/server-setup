#!/bin/sh
set -eu

SUDO_USER=
while [ -z "$SUDO_USER" ]; do
    printf 'Sudo username (the only user allowed to log in via SSH): '
    IFS= read -r SUDO_USER
done

AUTHORIZED_KEY=
while [ -z "$AUTHORIZED_KEY" ]; do
    printf 'Authorized SSH public key: '
    IFS= read -r AUTHORIZED_KEY
done

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
runuser -l "$SUDO_USER" -c 'sh -s' <<'USER_INSTALL'
echo "=== SSH"
cd || exit 1
mkdir -p .ssh
chmod 700 .ssh
cd .ssh || exit 1
touch authorized_keys
chmod 600 authorized_keys
if [ ! -e id_ed25519 ]; then
    ssh-keygen -q -t ed25519 -N "" -f id_ed25519
fi

echo "=== Update .bashrc"
cat >>~/.bashrc <<EOF

# sudo autocomplete
complete -cf sudo

# vim-like command line
set -o vi

# vim as default editor
export VISUAL=vim
export EDITOR="$VISUAL"

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
EOF

echo "=== Bash aliases"
cat >>~/.bash_aliases <<EOF
alias restart-nginx="sudo nginx -t && sudo /etc/init.d/nginx restart"
alias upgrade="sudo apt update; sudo apt upgrade; sudo apt autoremove"

# Use a long listing format
alias ll='ls -laFh'

# Show hidden files
alias l.='ls -d .* --color=auto'

alias untar='tar -zxvf'
alias untar-bz='tar -jxvf'

# System updates
alias ls='ls --color=auto'
alias df='df -H'
alias du='du -chs * | sort -h'
alias rsync='rsync -rPh --info=progress2'
EOF

echo "=== Tmux"
cat >>~/.tmux.conf <<EOF
# Remap prefix from 'C-b' to 'C-a'
unbind C-b
set-option -g prefix C-a
bind-key C-a last-window
bind-key C-c new-window

# Disable mouse mode
set -g mouse off

# Use vi key bindings
set -g status-keys vi
setw -g mode-keys vi

# Upgrade Terminal to 256-Color Mode
set -g default-terminal "screen-256color"

# Allows for faster key repetition
set -s escape-time 0
EOF

echo "=== .inputrc"
cat >>~/.inputrc <<EOF
set editing-mode vi
EOF

echo "=== .psqlrc"
cat >>~/.psqlrc <<EOF
\x auto
EOF

echo "=== Git config"
git config --global user.name "$(whoami)"
git config --global user.email "$(whoami)@$(hostname)"
git config --global core.editor "vim"
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.co checkout
USER_INSTALL

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
