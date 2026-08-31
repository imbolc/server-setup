# A common server setup

## Run from root

```sh
cd &&
wget --no-check-certificate -O setup-bookworm.sh https://raw.github.com/imbolc/server-setup/master/setup-bookworm.sh &&
sh setup-bookworm.sh
```

## Partials

All partials

```sh
curl -fsSL https://raw.github.com/imbolc/server-setup/master/partials/all.sh | sh
```

all partials for root from a sudo user

```sh
curl -fsSL https://raw.github.com/imbolc/server-setup/master/partials/all.sh | sudo sh
```

- essential cli tools
  ```sh
  curl -fsSL https://raw.github.com/imbolc/server-setup/master/partials/tools.sh | sh
  ```
- common bash aliases
  ```sh
  curl -fsSL https://raw.github.com/imbolc/server-setup/master/partials/aliases.sh | sh
  ```
- vimification
  ```sh
  curl -fsSL https://raw.github.com/imbolc/server-setup/master/partials/vimification.sh | sh
  ```
- vim
  ```sh
  curl -fsSL https://raw.github.com/imbolc/server-setup/master/partials/vim.sh | sh
  ```
- tmux
  ```sh
  curl -fsSL https://raw.github.com/imbolc/server-setup/master/partials/tmux.sh | sh
  ```
- git
  ```sh
  curl -fsSL https://raw.github.com/imbolc/server-setup/master/partials/git.sh | sh
  ```
