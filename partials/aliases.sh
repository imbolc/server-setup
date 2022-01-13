#!/usr/bin/env bash
set -euo pipefail

echo -en "bash aliases ... "

file="$HOME/.bash_aliases"
lines=(
    'alias restart-nginx="sudo nginx -t && sudo /etc/init.d/nginx restart"'
    'alias upgrade="sudo apt update; sudo apt upgrade; sudo apt autoremove"'
    'alias ls="ls --color=auto"'
    'alias ll="ls -laFh"'
    'alias df="df -H"'
    'alias du="du -chs * | sort -h"'
    'alias rsync="rsync -rPh --info=progress2"'
    'alias untar="tar -zxvf"'
    'alias untar-bz="tar -jxvf"'
)
for line in "${lines[@]}"; do
    grep -qxFs "$line" "$file" || echo "$line" >> "$file"
done

echo -e "\033[0;32mok\033[0m"
