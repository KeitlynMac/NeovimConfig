set number
set signcolumn=yes:1
"set statuscolumn=%s%=%{v:relnum?v:relnum:v:lnum}\ \ \ 
set numberwidth=2
set termguicolors
set belloff=all
set mouse=a
syntax enable
set showcmd
set ignorecase
set encoding=utf-8
set showmatch
set bg=dark
set showtabline=1
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

runtime! plugins/*.lua

so ~/.config/nvim/require.vim

so ~/.config/nvim/mappings.vim

so ~/.config/nvim/plug-conf.vim

" Desactivar la columna de estado en el Dashboard y NvimTree para que se vean limpios

autocmd FileType alpha,NvimTree setlocal statuscolumn= nonumber norelativenumber signcolumn=no 


if exists("g:neovide")
    " 1. Configura tu fuente Nerd Font y el tamaño
    set guifont=ZedMono\ Nerd\ Font:h14
    

    let g:neovide_maximized = v:true


    " 2. Efecto de vidrio / transparencia sutil en el fondo
    let g:neovide_opacity = 0.95

    " 3. Animaciones fluidas del cursor 
    let g:neovide_cursor_animation_length = 0.13
    let g:neovide_cursor_trail_size = 0.8
    
    " 4. Oculta el puntero del ratón al escribir
    let g:neovide_hide_mouse_when_typing = 1

    " 5. MAGIA PARA EL TÍTULO: Habilita el título y lo deja en blanco
    set title
    let &titlestring = " "
endif
