source $VIMRUNTIME/defaults.vim

colo sorbet
set background=dark
set mouse=
set autoindent
set colorcolumn=80
set nowrap
"set cursorline
set signcolumn=yes
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab
set laststatus=2
set incsearch
set hlsearch
set nocompatible
set ruler
set showcmd
set wildmenu
set visualbell
set confirm
set number
set termguicolors
set splitright
set splitbelow
set clipboard=unnamedplus
set foldmethod=manual
set completeopt+=menuone,noselect,noinsert
set pumheight=8
"set autochdir
set nobackup
set nowritebackup
set noswapfile
set nofoldenable
"set paste
autocmd FileType python set foldmethod=indent noexpandtab
autocmd FileType python map <F9> :w<CR>:!python3 %<CR>
filetype indent on
"hi CursorLine cterm=bold gui=bold ctermbg=black guibg=#222222
"hi CursorLineNr cterm=bold gui=bold ctermbg=black guibg=#222222

"autocmd VimEnter * :Lexplore
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:netrw_winsize = 20

map <F3> :Vexplore<cr>
map <F8> :w<cr>:!make build<cr>
map <F9> :w<cr>:!make run<cr>
map <F9> :w<cr>:!make<cr>
"inoremap " ""<left>
"inoremap ' ''<left>
"inoremap ( ()<left>
"inoremap [ []<left>
"inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

inoremap <C-e> <End>
inoremap <C-a> <Home>
inoremap <C-b> <Left>
inoremap <C-f> <Right>

highlight TrailingWhitespace ctermbg=red guibg=red
match TrailingWhitespace /\s\+$/

"set iskeyword-=_
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
