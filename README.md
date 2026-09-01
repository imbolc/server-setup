# A common server setup

## Run from root

```sh
(setup=$(curl -fsSL https://raw.github.com/imbolc/server-setup/master/setup-debian-12-bookworm.sh) && sh -c "$setup")
```

## Partials

All partials

```sh
(setup=$(curl -fsSL https://raw.github.com/imbolc/server-setup/master/partials/all.sh) && sh -c "$setup")
```

all partials for root from a sudo user

```sh
(setup=$(curl -fsSL https://raw.github.com/imbolc/server-setup/master/partials/all.sh) && sudo sh -c "$setup")
```

- essential cli tools
  ```sh
  (setup=$(curl -fsSL https://raw.github.com/imbolc/server-setup/master/partials/tools.sh) && sh -c "$setup")
  ```
- common bash aliases
  ```sh
  (setup=$(curl -fsSL https://raw.github.com/imbolc/server-setup/master/partials/aliases.sh) && sh -c "$setup")
  ```
- vimification
  ```sh
  (setup=$(curl -fsSL https://raw.github.com/imbolc/server-setup/master/partials/vimification.sh) && sh -c "$setup")
  ```
- vim
  ```sh
  (setup=$(curl -fsSL https://raw.github.com/imbolc/server-setup/master/partials/vim.sh) && sh -c "$setup")
  ```
- tmux
  ```sh
  (setup=$(curl -fsSL https://raw.github.com/imbolc/server-setup/master/partials/tmux.sh) && sh -c "$setup")
  ```
- git
  ```sh
  (setup=$(curl -fsSL https://raw.github.com/imbolc/server-setup/master/partials/git.sh) && sh -c "$setup")
  ```
