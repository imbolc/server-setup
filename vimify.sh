#!/usr/bin/env bash

tee -a ~/.bashrc > /dev/null << EOF
set -o vi
export VISUAL=vim
export EDITOR="$VISUAL"
EOF

tee ~/.inputrc > /dev/null << EOF
set editing-mode vi
EOF
