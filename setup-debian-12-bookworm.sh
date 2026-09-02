#!/bin/sh
set -eu

echo 'This installer is not idempotent. Do not run it twice.'
echo

echo "Collecting setup details"
printf 'Sudo username (the only user allowed to log in via SSH): '
IFS= read -r SUDO_USER </dev/tty

printf 'Authorized SSH public key: '
IFS= read -r AUTHORIZED_KEY </dev/tty

echo "Checking SSH user"
if getent passwd "$SUDO_USER" >/dev/null; then
    echo "User '$SUDO_USER' already exists. Setup requires a new SSH user." >&2
    exit 1
fi

echo "Configuring SSH user"
adduser --disabled-password --gecos "" "$SUDO_USER"

USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
USER_GROUP=$(id -gn "$SUDO_USER")
install -d -m 700 -o "$SUDO_USER" -g "$USER_GROUP" "$USER_HOME/.ssh"
AUTHORIZED_KEYS_PATH=$USER_HOME/.ssh/authorized_keys
install -m 600 -o "$SUDO_USER" -g "$USER_GROUP" /dev/null "$AUTHORIZED_KEYS_PATH"
printf '%s\n' "$AUTHORIZED_KEY" >"$AUTHORIZED_KEYS_PATH"

export DEBIAN_FRONTEND=noninteractive # Disable package prompts
export NEEDRESTART_MODE=a             # Restart services automatically

echo "Updating system"
apt-get update
apt-get -y upgrade

echo "Configuring sudo access"
apt-get -y install sudo
usermod -aG sudo "$SUDO_USER"

SUDOERS_FILE=/etc/sudoers.d/$SUDO_USER
printf '%s ALL=(ALL) NOPASSWD: ALL\n' "$SUDO_USER" >"$SUDOERS_FILE"
chmod 440 "$SUDOERS_FILE"
visudo -cf "$SUDOERS_FILE"

echo "Installing tools"
apt-get -y install \
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

echo "Updating root .bashrc"
cat >>~/.bashrc <<'EOF'

# vim-like command line
set -o vi

# vim as default editor
export VISUAL=vim
export EDITOR="$VISUAL"
EOF

echo "Configuring locales"
apt-get -y install locales
echo "LANG=en_DK.UTF-8" >/etc/default/locale
cat >/etc/locale.gen <<'EOF'
en_DK.UTF-8 UTF-8
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
EOF
/usr/sbin/locale-gen

echo "Configuring root Git"
git config --global core.editor "vim"
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.co checkout

echo "Installing Neovim"
apt-get -y install neovim
install -d -m 755 /usr/local/bin
ln -sT /usr/bin/nvim /usr/local/bin/vim || true

echo "Updating root .inputrc"
cat >>~/.inputrc <<'EOF'

set editing-mode vi
EOF

echo "Configuring $SUDO_USER"
runuser -l "$SUDO_USER" -c 'sh -s' <<'USER_INSTALL'
set -eu

echo "Configuring user SSH files"
cd

mkdir -p .ssh
chmod 700 .ssh
cd .ssh
touch authorized_keys
chmod 600 authorized_keys
if [ ! -e id_ed25519 ]; then
    ssh-keygen -q -t ed25519 -N "" -f id_ed25519
fi

echo "Updating user .bashrc"
cat >>~/.bashrc <<'EOF'

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

echo "Configuring Bash aliases"
cat >>~/.bash_aliases <<'EOF'

alias restart-nginx="sudo nginx -t && sudo /etc/init.d/nginx restart"
alias upgrade="sudo apt update && sudo apt upgrade && sudo apt autoremove"

# Use a long listing format
alias ll='ls -laFh'

# Show hidden files
alias l.='ls -d .* --color=auto'

alias untar='tar -zxvf'
alias untar-bz='tar -jxvf'

# File utilities
alias ls='ls --color=auto'
alias df='df -H'
alias rsync='rsync -rPh --info=progress2'
EOF

echo "Configuring tmux"
cat >>~/.tmux.conf <<'EOF'

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

echo "Updating user .inputrc"
cat >>~/.inputrc <<'EOF'

set editing-mode vi
EOF

echo "Updating user .psqlrc"
cat >>~/.psqlrc <<'EOF'

\x auto
EOF

echo "Configuring user Git"
git config --global user.name "$(whoami)"
git config --global user.email "$(whoami)@$(hostname)"
git config --global core.editor "vim"
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.co checkout
USER_INSTALL

echo "Restricting SSH authentication"
SSHD_CONFIG=/etc/ssh/sshd_config.d/00-server-setup.conf
install -d -m 755 /etc/ssh/sshd_config.d
install -m 644 /dev/null "$SSHD_CONFIG"
cat >"$SSHD_CONFIG" <<EOF
PubkeyAuthentication yes
AuthenticationMethods publickey
AuthorizedKeysFile .ssh/authorized_keys
PasswordAuthentication no
KbdInteractiveAuthentication no
PermitRootLogin no
AllowUsers $SUDO_USER
EOF
/usr/sbin/sshd -t
systemctl reload ssh.service

echo
echo "Everything is done, congrats :)"
echo "Now only $SUDO_USER is allowed to access the server by ssh with only public key authorization option"
echo "Before closing this session verify that you can log in: ssh $SUDO_USER@your_server_ip"
