# from root
bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/vimification.sh)
bash

apt update && apt upgrade -y

# disable sudo password
read -p "Enter a username for sudo user: " -i user -e sudo_user
echo "$sudo_user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$sudo_user

# === ssh keys
ssh-add

# === hybrid graphics
sudo apt install -y \
    bumblebee-nvidia \
    primus mesa-utils \
    xserver-xorg-input-mouse \

sudo ln -s /usr/share/X11/xorg.conf.d /etc/bumblebee/xorg.conf.d
sudo systemctl restart bumblebeed

# test integrated graphic card
glxinfo | grep "OpenGL renderer"

# hybrid nvidia card
# if there's an error, uncomment `BusID` in `/etc/bumblebee/xorg.conf.nvidia`
optirun glxinfo | grep "OpenGL renderer"

# === libs
sudo apt install \
  libbz2-dev \
  libcairo2 \
  libffi-dev \
  liblzma-dev \
  libncursesw5-dev \
  libpango1.0-0 \
  libreadline-dev \
  libsqlite3-dev  \
  libssl-dev \
  libsystemd-dev \
  libxml2-dev \
  libxmlsec1-dev \
  tk-dev \
  zlib1g-dev \

# === CLI tools
sudo apt install \
  build-essential \
  curl \
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
  xz-utils \

sudo su postgres -c "cd /; createuser -s $USER"


# === vim
sudo apt remove -y vim 
pip3 install ranger-fm pynvim
sudo curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o /usr/bin/vim
sudo chmod +x /usr/bin/vim


git clone git@github.com:imbolc/nvim.git ~/.config/nvim
# throws errors, could make sense to run multiple times
vim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# === apps
# pub `flameshot gui` to PrtSrc
sudo apt install \
  blueman \
  flameshot \
  gitk \
  kazam \
  keepassxc \
  openvpn \
  qbittorrent \
  terminator \
  vlc \
  xclip \

# === python
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
git clone https://github.com/pyenv/pyenv-update.git ~/.pyenv/plugins/pyenv-update

# === rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup target add x86_64-unknown-linux-musl
rustup component add rustfmt clippy rust-src rust-analyzer

cargo install --locked \
  bottom \
  cargo-expand \
  cargo-generate \
  cargo-limit \
  cargo-readme \
  cargo-sync-readme \
  cargo-watch \
  comrak \
  fd-find \
  git-delta \
  mask \
  ripgrep \
  rust-script \
  rusty-hook \
  skim \
  sqlx-cli \
  stylua \
  taplo-cli \
  tealdeer \
  typos-cli \
  xplr \

# === switch to bluetooth headbuds on connection, details: https://gist.github.com/diffficult/37360df0824137e04659e7f5ebf9a561
sudo sed -i '/load-module module-bluetooth-discover/a load-module module-switch-on-connect' /etc/pulse/default.pa
pulseaudio -k

# === limit CPU performance
sudo apt install powercap-utils
sudo tee -a /etc/systemd/system/cpu-powercap.service > /dev/null << EOF
[Unit]
Description=Limit CPU performance

[Service]
ExecStart=/usr/bin/powercap-set -p intel-rapl -z 0 -c 1 -l 30000000
Type=oneshot
RemainAfterExit=yes
User=root

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable cpu-powercap
sudo systemctl start cpu-powercap
sudo systemctl status cpu-powercap
