#!/usr/bin/env bash
set -euo pipefail

echo -en "vim ... "

sudo apt -qqq update
sudo apt install -qqqy vim

FNAME='~/.vimrc'
test -f $FNAME && echo "already exists"
test -f $FNAME || tee -a ~/.vimrc > /dev/null << EOF
set nocompatible
let mapleader=","

" do not create backups
set nobackup
set noswapfile
set nowritebackup

set nowrap
set novisualbell
set t_vb=
set backspace=indent,eol,start whichwrap+=<,>,[,]

syntax on
set ttyfast
set ruler               " show the cursor position all the time
set history=50          " history of commands
set undolevels=500      " history of undos

set statusline=%<%f%h%m%r%=(%{&fileencoding},%{&encoding})\ (%b,0x%B)\ %l,%c%V\ %P
set laststatus=2

set showcmd             " display incomplete commands
set autoread            " automatically re-read changed files, works only in GUI
set autowrite           " automatically :write before running commands
set nonumber
set foldmethod=syntax
set foldlevelstart=200  " open all folds when opening a file

" indent
set smarttab
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set autoindent

" encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp1251,koi8-r,cp866,ucs-bom,ascii
set fileformat=unix
set fileformats=unix,dos,mac

" search
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
set gdefault

" reselect visual block after indent/outdent  
vnoremap < <gv
vnoremap > >gv

" easy split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
EOF

echo -e "\033[0;32mcreated\033[0m"
