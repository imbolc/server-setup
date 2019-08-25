Setup Debian Stretch server
==========================

Run from root
-------------
    # cd && wget --no-check-certificate https://raw.github.com/imbolc/stretch-setup/master/root-install.sh && bash root-install.sh

Non-root user
-------------
- Add a user: `adduser user`
- Add them into `sudo` group: `# usermod -a -G sudo user`
- Change `/etc/sudoers` with `visudo` to disable password input: `%sudo   ALL=(ALL) NOPASSWD: ALL`


Run from user
-------------
    # su user
    $ cd && wget --no-check-certificate https://raw.github.com/imbolc/stretch-setup/master/user-install.sh && bash user-install.sh


Setup ssh pubkey auth
---------------------
Copy pubkey from local mashine:

    local@mashine$ ssh-copy-id user@sever_ip

Generate local keys:

    ssh-keygen -t rsa


**sudo vim /etc/ssh/sshd_config**

    # disable password auth
    PasswordAuthentication no

    # disable root login
    PermitRootLogin no

    # ssh access allowed user list
    AllowUsers user

Restart ssh daemon: 

    sudo reboot


Install python
--------------
1. Look at avaliable versions with `pyenv install --list`
2. Install the last versions with `pyenv install <version>`
3. Set default versions with: `cd; pyenv local 2.x.y 3.x.y`


Install postgres
----------------
    sudo apt update
    sudo apt install postgresql-9.6 postgresql-server-dev-9.6
    sudo su postgres -c "cd /; createuser -s user"
