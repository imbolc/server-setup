#!/bin/sh
set -eu

printf 'vimification ... '

append_missing_lines() {
    file=$1
    while IFS= read -r line; do
        grep -Fqx "$line" "$file" 2>/dev/null || printf '%s\n' "$line" >> "$file"
    done
}

# bash
append_missing_lines "$HOME/.bashrc" <<'EOF'
set -o vi
export VISUAL=vim
export EDITOR="$VISUAL"
EOF

# input
append_missing_lines "$HOME/.inputrc" <<'EOF'
set editing-mode vi
EOF

# tmux
append_missing_lines "$HOME/.tmux.conf" <<'EOF'
set -g status-keys vi
setw -g mode-keys vi
EOF

printf '\033[0;32mok\033[0m\n'
