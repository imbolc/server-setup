A common server setup
=====================

Run from root
-------------
```sh
cd && wget --no-check-certificate https://raw.github.com/imbolc/server-setup/master/bullseye/root-install.sh && bash root-install.sh
```

Ubuntu version:

```sh
cd && wget --no-check-certificate https://raw.github.com/imbolc/server-setup/master/focal/root-install.sh && bash root-install.sh
```

Partials
--------
All partials

```sh
bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/all.sh)
```

all partials for root from a sudo user

```sh
sudo su -c 'bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/all.sh)'
```

* essential cli tools
    ```sh
    bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/tools.sh)
    ```
* common bash aliases
    ```sh
    bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/aliases.sh)
    ```
* vimification
    ```sh
    bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/vimification.sh)
    ```
* vim
    ```sh
    bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/vim.sh)
    ```
* tmux
    ```sh
    bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/tmux.sh)
    ```
* git
    ```sh
    bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/git.sh)
    ```

Install python
--------------
1. Look at available versions with `pyenv install --list`
2. Install the last versions with `pyenv install 3.x.y`
3. Set it as the default versions with: `pyenv global 3.x.y`


Postgres
--------

    echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' | sudo tee /etc/apt/sources.list.d/pgdg.list
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    sudo apt update
    sudo apt install postgresql-13 postgresql-server-dev-13
    sudo su postgres -c "cd /; createuser -s $USER"

Node
----

    sudo curl -sL https://deb.nodesource.com/setup_13.x | sudo bash -
    sudo apt install -y nodejs
