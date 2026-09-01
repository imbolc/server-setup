#!/bin/sh
set -eu

printf 'bash aliases ... '

file=$HOME/.bash_aliases
if [ -s "$file" ] && [ -n "$(tail -c 1 "$file")" ]; then
    printf '\n' >>"$file"
fi

while IFS= read -r line; do
    grep -Fqx "$line" "$file" 2>/dev/null || printf '%s\n' "$line" >> "$file"
done <<'EOF'
alias restart-nginx="sudo nginx -t && sudo /etc/init.d/nginx restart"
alias upgrade="sudo apt update && sudo apt upgrade && sudo apt autoremove"
alias ls="ls --color=auto"
alias ll="ls -laFh"
alias df="df -H"
alias rsync="rsync -rPh --info=progress2"
alias untar="tar -zxvf"
alias untar-bz="tar -jxvf"
EOF

printf '\033[0;32mok\033[0m\n'
