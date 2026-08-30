#!/bin/sh
set -eu

temporary_directory=$(mktemp -d)
cleanup() {
    rm -rf "$temporary_directory"
}
trap cleanup 0
trap 'exit 1' HUP INT TERM

run_partial() {
    url=$1
    curl -fsSL "$url" -o "$temporary_directory/partial.sh"
    sh "$temporary_directory/partial.sh"
}

base_url=https://raw.github.com/imbolc/server-setup/master/partials
run_partial "$base_url/tools.sh"
run_partial "$base_url/vimification.sh"
run_partial "$base_url/vim.sh"
run_partial "$base_url/tmux.sh"
run_partial "$base_url/git.sh"
run_partial "$base_url/aliases.sh"

printf '\033[0;32mOK: \033[0mall partials run successfully\n'
