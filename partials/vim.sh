#!/usr/bin/env bash

set -o nounset errexit
echo -en "  vimification ... "

tee -a ~/.bashrc > /dev/null << EOF
set -o vi
export VISUAL=vim
export EDITOR="$VISUAL"
EOF

tee -a ~/.inputrc > /dev/null << EOF
set editing-mode vi
EOF

echo -e "\033[0;32mok\033[0m"
