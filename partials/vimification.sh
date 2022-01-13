#!/usr/bin/env bash
set -euo pipefail

echo -en "vimification ... "

# bash
file="$HOME/.bashrc"
lines=(
    'set -o vi'
    'export VISUAL=vim'
    'export EDITOR="$VISUAL"'
)
for line in "${lines[@]}"; do
    grep -qxFs "$line" "$file" || echo "$line" >> "$file"
done

# input
file="$HOME/.inputrc"
lines=(
    'set editing-mode vi'
)
for line in "${lines[@]}"; do
    grep -qxFs "$line" "$file" || echo "$line" >> "$file"
done

# tmux
file="$HOME/.tmux.conf"
lines=(
    'set -g status-keys vi'
    'setw -g mode-keys vi'
)
for line in "${lines[@]}"
do
    grep -qxFs "$line" "$file" || echo "$line" >> "$file"
done

echo -e "\033[0;32mok\033[0m"
