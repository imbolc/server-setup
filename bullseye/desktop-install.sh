# settings
ssh-add

# hybrid graphics
sudo apt install bumblebee-nvidia primus

# libs
sudo apt install \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev  \
  libncursesw5-dev \
  tk-dev \
  libxml2-dev \
  libxmlsec1-dev \
  libffi-dev \
  liblzma-dev \
  libsystemd-dev \
  libcairo2 \
  libpango1.0-0 \


# CLI tools
sudo apt install \
  build-essential \
  curl \
  flatpak \
  git \
  highlight \
  htop \
  llvm \
  make \
  mc \
  mosh \
  ncdu \
  nodejs \
  npm \
  podman \
  postgresql \
  python3-pip \
  python3-venv \
  ranger \
  redis \
  rsync \
  tmux \
  tree \
  wget \
  wrk \
  xfce4 \
  xz-utils \


echo "Vim"
sudo apt remove -y vim 
pip3 install ranger-fm pynvim
sudo curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o /usr/bin/vim
sudo chmod +x /usr/bin/vim

echo "Flatpack"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Telegram"
flatpak install -y flathub org.telegram.desktop

echo "Skype"
wget https://go.skype.com/skypeforlinux-64.deb
sudo apt install ./skypeforlinux-64.deb
rm ./skypeforlinux-64.deb

echo "Firefox"
sudo apt remove -y firefox-esr
flatpak install -y flathub org.mozilla.firefox

echo "FreeTube"
flatpak install flathub io.freetubeapp.FreeTube

echo "=== Autostart"
mkdir -p ~/.config/autostart
ln -s /usr/share/applications/google-chrome.desktop ~/.config/autostart/
ln -s /usr/share/applications/org.keepassxc.KeePassXC.desktop ~/.config/autostart/
ln -s /usr/share/applications/skypeforlinux.desktop ~/.config/autostart/
ln -s /usr/share/applications/terminator.desktop ~/.config/autostart/
ln -s /var/lib/flatpak/exports/share/applications/org.telegram.desktop.desktop ~/.config/autostart/


# apps
sudo apt install \
  deepin-screenshot \
  terminator \
  gitk \
  keepassxc \
  qbittorrent \
  blueman \
  xclip \

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install \
  cargo-expand \
  git-delta \
  cargo-watch \
  ripgrep \
  fd-find \
  cross \
  taplo-cli \
  stylua \
  mask \

rustup target add x86_64-unknown-linux-musl

# python
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

sudo npm i -g diff-so-fancy


# Whonix
## KVM
sudo apt install --no-install-recommends qemu-kvm libvirt-daemon-system libvirt-clients virt-manager gir1.2-spiceclientgtk-3.0 dnsmasq qemu-utils
sudo addgroup "$(whoami)" libvirt
sudo addgroup "$(whoami)" kvm
# Download Whonix: https://www.whonix.org/wiki/KVM
tar -xvf Whonix*.libvirt.xz

## Allow libvirt images to be symlinked to a mounted device
chmod -R o+rx /media/imbolc/

# root .bashrc
sudo tee -a /root/.bashrc > /dev/null << EOF
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -d "/snap/bin" ] ; then
    PATH="/snap/bin:$PATH"
fi
EOF

# Mount encrypted disks without requesting user password
sudo tee /etc/polkit-1/localauthority/50-local.d/50-easy-mount-encrypted.pkla > /dev/null << EOF
[Allow local mounting of encrypted disks without password]
Identity=unix-group:sudo;unix-group:plugdev
Action=org.freedesktop.udisks2.encrypted-unlock-system
ResultActive=yes
EOF
