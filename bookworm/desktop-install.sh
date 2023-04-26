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

# === apps
sudo apt install \
  deepin-screen-recorder \
  terminator \
  gitk \
  keepassxc \
  qbittorrent \
  blueman \
  xclip \

# === python
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
git clone https://github.com/pyenv/pyenv-update.git ~/.pyenv/plugins/pyenv-update

# === rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install \
  cargo-expand \
  cargo-watch \
  fd-find \
  git-delta \
  mask \
  ripgrep \
  rusty-hook \
  skim \
  sqlx-cli \
  stylua \
  taplo-cli \
  typos-cli \
  bottom \
  cargo-limit \
  cargo-sync-readme \

rustup target add x86_64-unknown-linux-musl