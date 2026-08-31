#!/usr/bin/env sh

set -eu

# Linking the script as the pre-commit hook
SCRIPT_PATH=$(realpath "$0")
HOOK_PATH=$(git rev-parse --git-dir)/hooks/pre-commit

if [ "$(realpath "$HOOK_PATH")" != "$SCRIPT_PATH" ]; then
    printf "Link this script as the git pre-commit hook to avoid further manual running? (y/N): "
    read -r link_hook
    case "$link_hook" in
    [Yy])
        ln -sf "$SCRIPT_PATH" "$HOOK_PATH"
        ;;
    esac
fi

set -x

typos --version >/dev/null 2>&1 || cargo install --locked typos-cli
typos .

find ./ -type f -name '*.sh' -print0 | xargs -0 shellcheck -ax
