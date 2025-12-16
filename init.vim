set number
set signcolumn=auto
set numberwidth=6
set termguicolors
set belloff=all
set mouse=a
syntax enable
set showcmd
set ignorecase
set encoding=utf-8
set showmatch
set bg=dark
set smarttab
set cindent
set expandtab
set autoindent
set tabstop=4
set shiftwidth=4
set laststatus=2
set statusline+=%F 
set updatetime=100
"terminal abajo
set splitbelow
set splitright
"wrap que los párrafos se acomoden
set textwidth=0
set wrapmargin=0
set wrap
set linebreak
"Spell
set shell=bash
set shellcmdflag=-lc


so ~/.config/nvim/plugins.vim
runtime! config/*.lua
runtime! plugins/*.lua
so ~/.config/nvim/require.vim
so ~/.config/nvim/mappings.vim
so ~/.config/nvim/plug-conf.vim

