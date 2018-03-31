#!/bin/bash

echo "=== SSH"
cd; mkdir .ssh; chmod 700 .ssh; cd .ssh; touch authorized_keys; chmod 600 authorized_keys


echo "=== VIM"
rm -R ~/.vim ~/.vimrc
git clone https://github.com/imbolc/.vim ~/.vim
mkdir ~/.config
ln -s ~/.vim ~/.config/nvim
nvim +PlugInstall +qall

cd ~/.vim
python3 -m venv py3env
./py3env/bin/pip install wheel
./py3env/bin/pip install -r requirements.txt


echo "=== Enable sudo autocomplete, vim-like comand line"
cat >> ~/.bashrc << EOF

# sudo autocomplete
complete -cf sudo

# vim-like comand line
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
cat >> ~/.bash_aliases << EOF
alias nginx-restart="sudo nginx -t && sudo /etc/init.d/nginx restart"
alias upgrade="sudo aptitude update; sudo aptitude upgrade"
alias chmod-standard="find ./ -type d | xargs chmod -v 755 ; find ./ -type f | xargs chmod -v 644"
alias rm-pyc-files="find . -name '*.pyc' -exec rm '{}' ';'"

# Use a long listing format
alias ll='ls -la'

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
cat >> ~/.tmux.conf << EOF
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
cat >> ~/.inputrc << EOF
set editing-mode vi
set enable-bracketed-paste on
EOF

echo "=== Git config"
git config --global user.name $(whoami)
git config --global user.email $(whoami)@$(hostname)
git config --global core.editor "vim"
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.co checkout

echo "=== Pyenv"
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
cat >> ~/.bashrc << 'EOF'

# pyenv
export PYENV_ROOT="${HOME}/.pyenv"
if [ -d "${PYENV_ROOT}" ]; then
  export PATH="${PYENV_ROOT}/bin:${PATH}"
  eval "$(pyenv init -)"
fi
EOF
