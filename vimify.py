import os
from pathlib import Path

UPDATES = [
    [
        "~/.bashrc",
        [
            "set -o vi",
            "export VISUAL=vim",
            "export EDITOR=vim",
            "complete -cf sudo",
        ],
    ],
    ["~/.inputrc", ["set editing-mode vi"]],
    [
        "~/.ipython/profile_default/ipython_config.py",
        ["c.TerminalInteractiveShell.editing_mode = 'vi'"],
    ],
]
BASE_VIM_CONFIG = """
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

set showcmd             " display incomplete commands
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
"""


def update_files():
    for path, updates in UPDATES:
        path = Path(path).expanduser()
        if not path.exists():
            print("touch", path)
            path.touch()
        text = path.read_text()
        for update in updates:
            if update not in text:
                print(str(path) + " << " + update)
                with path.open("a") as f:
                    if text and not text.endswith("\n"):
                        f.write("\n")
                        text += "\n"
                    f.write(update + "\n")


def is_pip_installed():
    return not os.system("pip -V > /dev/null")


def install_pip():
    if is_pip_installed():
        return True
    cmd = "apt install -y python3-pip > /dev/null"
    if am_i_root():
        if not os.system(cmd):
            return True
    if has_sudo_access():
        if not os.system("sudo " + cmd):
            return True


def is_ipython_installed():
    return not os.system("ipython -V > /dev/null")


def install_ipython():
    if is_ipython_installed():
        return
    if not install_pip():
        print("can't install pip")
        return
    print("installing ipython")
    os.system("pip3 install ipython > /dev/null")
    os.system("python3 -m IPython profile create > /dev/null")


def is_vim_config_exists():
    paths = ["~/.vimrc", "~/.config/nvim"]
    for path in paths:
        if Path(path).expanduser().exists():
            return True


def add_base_vim_config():
    if is_vim_config_exists():
        return
    print("creating a base vim config")
    path = Path("~/.vimrc").expanduser()
    with path.open("w") as f:
        f.write(BASE_VIM_CONFIG)
    nvim = Path("~/.config/nvim/init.vim").expanduser()
    nvim.parent.mkdir(parents=True, exist_ok=True)
    nvim.symlink_to(path)


def has_sudo_access():
    if am_i_root():
        return False
    return not os.system("sudo -n ls > /dev/null")


def am_i_root():
    return os.geteuid() == 0


def run_as_root():
    if not has_sudo_access():
        return
    path = Path(__file__).resolve()
    os.system("sudo python3 {} > /dev/null".format(path))


if __name__ == "__main__":
    install_ipython()
    update_files()
    add_base_vim_config()
    run_as_root()
