call plug#begin('~/.vim/plugged')


"THEMES
Plug 'rebelot/kanagawa.nvim'
Plug 'luisiacc/gruvbox-baby', {'branch': 'main'}
Plug 'ellisonleao/gruvbox.nvim'
Plug 'sainnhe/everforest'

"Dashboard
Plug 'goolord/alpha-nvim'

"cursor
Plug 'sphamba/smear-cursor.nvim'


"Iconos
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'kosayoda/nvim-lightbulb'


"Iconos para el cmp
Plug 'onsails/lspkind.nvim'

"Error Leans
Plug 'rachartier/tiny-inline-diagnostic.nvim'

"Rename
Plug 'smjonas/inc-rename.nvim'

"Terminal
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}


"Atajos
Plug 'folke/which-key.nvim'


"Cambiar de rama

Plug 'ahmedkhalf/project.nvim'


"STYLESLINE

Plug 'akinsho/bufferline.nvim', { 'tag': '*' }

Plug 'nvim-lualine/lualine.nvim'


"Diccionario programador

Plug 'psliwka/vim-dirtytalk', { 'do': ':DirtytalkUpdate' }


"Prettier

Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production'}

Plug 'mhartington/formatter.nvim'


"LiveServer

Plug 'barrett-ruth/live-server.nvim'


"INDEntLIne

Plug 'lukas-reineke/indent-blankline.nvim'



"Mover parrafo seleccionado
Plug 'echasnovski/mini.move'


"cursor line
Plug 'echasnovski/mini.cursorword'


"Interfaz
Plug 'MunifTanjim/nui.nvim'

Plug 'folke/noice.nvim'

Plug 'folke/trouble.nvim', { 'dependencies': 'nvim-tree/nvim-web-devicons' }



"Tressiter

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}


  "Autopairs

 Plug 'windwp/nvim-autopairs'


   "Css colors

 Plug 'ap/vim-css-color' 



  "Plenary

 Plug 'nvim-lua/plenary.nvim'



  "Telescope

 Plug 'nvim-lua/plenary.nvim'

 Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }


  "Closetag

 Plug 'alvan/vim-closetag'


  "Surround

Plug 'tpope/vim-surround'




 Plug 'echasnovski/mini.nvim'

 Plug 'echasnovski/mini.diff'



  "Search

 Plug 'easymotion/vim-easymotion'


  "NERDTree 

 Plug 'nvim-tree/nvim-web-devicons'   "optional

 Plug 'nvim-tree/nvim-tree.lua'

 "Plug 'scrooloose/nerdtree'



  "Tmux

 Plug 'christoomey/vim-tmux-navigator'


  "LSP

 Plug 'neovim/nvim-lspconfig' 




  "PLUGINS PARA JS

 Plug 'pangloss/vim-javascript'

 Plug 'maxmellon/vim-jsx-pretty'


  "SNIPPETS PARA JS

 Plug 'SirVer/ultisnips'

 Plug 'mlaursen/vim-react-snippets'


  "Emme

 Plug 'mattn/emmet-vim'


  "COMENTARIOS

 Plug 'tpope/vim-commentary'


  "Multi cursor

 Plug 'mg979/vim-visual-multi', {'branch': 'master'}


  "Autocomplete 


 Plug 'hrsh7th/cmp-buffer'

 Plug 'hrsh7th/cmp-nvim-lsp'

 Plug 'hrsh7th/cmp-path'

 Plug 'hrsh7th/cmp-cmdline'

 Plug 'hrsh7th/nvim-cmp'

 Plug 'hrsh7th/cmp-vsnip'

 Plug 'hrsh7th/vim-vsnip'

 Plug 'hrsh7th/vim-vsnip-integ'

 Plug 'golang/vscode-go'

Plug 'L3MON4D3/LuaSnip'


  "Java

 Plug 'mfussenegger/nvim-jdtls'

 Plug 'williamboman/mason.nvim'

 Plug 'mikelue/vim-maven-plugin'

 Plug 'mfussenegger/nvim-dap'

 Plug 'rcarriga/nvim-dap-ui'


 "---quickfix---
Plug 'nvim-telescope/telescope-ui-select.nvim'


"Git
Plug 'lewis6991/gitsigns.nvim'



 call plug#end()
