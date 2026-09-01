#!/bin/sh
set -eu

printf 'vimification ... '

install_vimification() {
    file=$1
    temporary_file=$(mktemp)

    if [ -f "$file" ]; then
        sed '/^# BEGIN server-setup vimification$/,/^# END server-setup vimification$/d' \
            "$file" >"$temporary_file"
        cat "$temporary_file" >"$file"
    fi
    rm -f "$temporary_file"

    if [ -s "$file" ] && [ -n "$(tail -c 1 "$file")" ]; then
        printf '\n' >>"$file"
    fi

    {
        printf '%s\n' '# BEGIN server-setup vimification'
        cat
        printf '%s\n' '# END server-setup vimification'
    } >>"$file"
}

# bash
install_vimification "$HOME/.bashrc" <<'EOF'
set -o vi
export VISUAL=vim
export EDITOR="$VISUAL"
EOF

# input
install_vimification "$HOME/.inputrc" <<'EOF'
set editing-mode vi
EOF

# tmux
install_vimification "$HOME/.tmux.conf" <<'EOF'
set -g status-keys vi
setw -g mode-keys vi
EOF

printf '\033[0;32mok\033[0m\n'
