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


echo "=== Enable sudo autocomplete, vim-like comand line, screen tabs auto-naming"
cat >> ~/.bashrc << EOF

# sudo autocomplete
complete -cf sudo

# vim colors in screen
export TERM='xterm-256color'

# vim-like comand line
set -o vi

# vim as default editor
export VISUAL=vim
export EDITOR="$VISUAL"

# auto-change tabname in screen
export PROMPT_COMMAND='echo -ne "\033k\033\0134"'

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
alias vim="nvim"
EOF

echo "=== Screen"
cat >> ~/.screenrc << EOF
startup_message off
defutf8 on
vbell on

# vim colors
term xterm-256color
attrcolor b ".I"
termcapinfo xterm 'Co#256:AB=\E[48;5;%dm:AF=\E38;5;%dm'
defbce "on"

# default buffer of scroll
defscrollback 1000

# activate xterm scroll
termcapinfo xterm* ti@:te@

# Строка состояния
# для авто-названий табов в ~/.bashrc включить:
# export PROMPT_COMMAND='echo -ne "\033k\033\0134"'
shelltitle "$ |bash"
hardstatus alwayslastline "%-w%{= BW}%50>%n %t%{-}%+w%<"
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
