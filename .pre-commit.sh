#!/usr/bin/env sh

set -eu

# Linking the script as the pre-commit hook
SCRIPT_PATH=$(realpath "$0")
HOOK_DIRECTORY=$(git rev-parse --path-format=absolute --git-path hooks)
HOOK_PATH=$HOOK_DIRECTORY/pre-commit

if [ ! -e "$HOOK_PATH" ] && [ ! -L "$HOOK_PATH" ]; then
    printf "Link this script as the git pre-commit hook to avoid further manual running? (y/N): "
    if read -r link_hook; then
        case "$link_hook" in
        [Yy])
            mkdir -p "$HOOK_DIRECTORY"
            ln -s "$SCRIPT_PATH" "$HOOK_PATH"
            ;;
        esac
    fi
fi

set -x

typos --version >/dev/null 2>&1 || cargo install --locked typos-cli
typos .

git grep -Ilz -e '' -- '*.sh' | xargs -0 -r shellcheck -ax --
