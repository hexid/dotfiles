" Plugins (junegunn/vim-plug)
call plug#begin()
Plug 'airblade/vim-gitgutter'
Plug 'chrisbra/Recover.vim'
Plug 'chriskempson/base16-vim'
Plug 'edkolev/tmuxline.vim'
Plug 'felixjung/vim-base16-lightline'
Plug 'itchyny/lightline.vim'
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'tpope/vim-fugitive'
call plug#end()

" color scheme
set background=dark
set t_Co=256
let base16colorspace=256
colorscheme base16-default-dark

" lightline
set laststatus=2 " always show the status line (shows blank line)
set ttimeoutlen=50
set noshowmode " hide default mode indicator
let g:lightline={
\ 'colorscheme': 'base16_default',
\}

" tmuxline
let g:tmuxline_preset={
	\'a'       : '#S',
	\'win'     : ['#I', '#W'],
	\'cwin'    : ['#I', '#W', '#F'],
	\'z'       : '#H',
	\'options' : {'status-justify' : 'left'}
	\}
let g:tmuxline_powerline_separators=0
let g:tmuxline_theme='lightline'

cnoremap w! w !sudo tee % >/dev/null

vmap <C-c> "+yi
vmap <C-x> "+c
set pastetoggle=<F2>

set mouse=a

set listchars=tab:▸\ ,space:·,trail:+,extends:▸,precedes:◂,nbsp:+
set list
set number " enable line numbers

" default to 2 length tab
set tabstop=2 | set shiftwidth=2 | set softtabstop=2 | set noexpandtab
" use spaces for tabs
autocmd FileType yaml set expandtab
" use 4 spaces for tabs
autocmd FileType python,rust set tabstop=4 | set shiftwidth=4 | set softtabstop=4 | set expandtab

filetype plugin indent on
syntax on

set cursorline " highlight current line

set incsearch
set hlsearch

