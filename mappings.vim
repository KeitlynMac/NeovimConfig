
"Telescope configuration
" Find files using Telescope command-line sugar.
nnoremap <space>ff <cmd> :Telescope find_files<cr>
nnoremap <space>fa <cmd> :Telescope live_grep<cr>
nnoremap <space>hj <cmd> :Telescope buffers<cr>
nnoremap <space>g <cmd> :Telescope help_tags<cr>

" Volver al Dashboard (Home) con Leader + h
nnoremap <space>h :Alpha<CR>


" CONFIGURACION DE COMENTARIOS
nnoremap  <silent><space>/ :Commentary<CR>
vnoremap  <silent><space>/ :Commentary<CR>

"NvimTree
nnoremap <silent><space>a :NvimTreeOpen <CR>
nnoremap <silent><space>n :NvimTreeClose <CR>

"Split resize
nnoremap <space>. 10<C-w>>
nnoremap <space>, 10<C-w><

"buffers
nnoremap <silent><space>k :bnext<CR>
nnoremap <silent><space>j :bprevious<CR>
nnoremap <silent><space>d :bdelete<CR>

"Scrolling faster
nnoremap <space>i 20<C-e>
nnoremap <space>o 20<C-y>
map <space>s <Plug>(easymotion-s2)


"vsplit
nnoremap <space>v :vsplit<CR>

" punto y coma al final
nnoremap <space>; $a;<CR>

"Guardar 
nmap <silent><C-s> :w<CR>
imap <silent><C-s> <c-o>:w<CR>

"Remplazar palabra
nnoremap re yiw:%s/<C-r>0//g<Left><Left>

"Java completado

"noh
noremap <leader>no yiw:noh<CR>

"Salir
nmap <silent><C-a> :q<CR>
imap <silent><C-a> <c-e>:q<CR>

"Escape
inoremap jk <esc>


