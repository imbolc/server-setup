#!/usr/bin/env bash

set -o nounset errexit
echo -en "  tmux ...         "

tee ~/.tmux.conf > /dev/null << EOF
unbind C-b
set-option -g prefix C-a

bind-key C-a last-window
bind-key C-c new-window
bind k confirm kill-window

set -g status-keys vi
setw -g mode-keys vi

set -g mouse off
set -g default-terminal "screen-256color"
set -s escape-time 0

setw -g window-status-current-format ' #I #W '
setw -g window-status-format ' #I #W '
set-window-option -g window-status-separator ''

set -g status-bg black
setw -g window-status-current-style bg=brightblue,fg=brightwhite
setw -g window-status-style fg=white

set -g status-left  '#[bg=white]#[fg=black]'
EOF

echo -e "\033[0;32mok\033[0m"
