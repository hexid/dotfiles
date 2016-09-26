if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME="$HOME/.config" | endif
if empty($XDG_CACHE_HOME) | let $XDG_CACHE_HOME="$HOME/.cache" | endif
set directory=$XDG_CACHE_HOME/nvim/swp,~/tmp,/tmp
set backupdir=$XDG_CACHE_HOME/nvim,~/tmp,/tmp

" Plugins (junegunn/vim-plug)
call plug#begin('$XDG_CONFIG_HOME/nvim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'chrisbra/Recover.vim'
Plug 'chriskempson/base16-vim'
Plug 'edkolev/tmuxline.vim'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-fugitive'
call plug#end()

" color scheme
set background=dark
set t_Co=256
let base16colorspace=256
colorscheme base16-default
let g:airline_theme='base16'

" airline
set laststatus=2 " always show the status line (shows blank line)
set ttimeoutlen=50
set noshowmode " hide default mode indicator
let g:airline_powerline_fonts = 1 " enable powerline fonts

" tmuxline
let g:tmuxline_preset = {
	\'a'       : '#S',
	\'win'     : ['#I', '#W'],
	\'cwin'    : ['#I', '#W', '#F'],
	\'z'       : '#H',
	\'options' : {'status-justify' : 'left'}
	\}

cnoremap w! w !sudo tee % >/dev/null

vmap <C-c> "+yi
vmap <C-x> "+c
set pastetoggle=<F2>

set listchars=tab:▸\ ,space:·,trail:+,extends:▸,precedes:◂,nbsp:+
set list
set number " enable line numbers

" default to 2 length tab
set tabstop=2 | set shiftwidth=2 | set softtabstop=2 | set noexpandtab
" use spaces for tabs
autocmd FileType yaml set expandtab
" use 4 spaces for tabs
autocmd FileType python,rust,javascript set tabstop=4 | set shiftwidth=4 | set softtabstop=4 | set expandtab

filetype plugin indent on
syntax on

set cursorline " highlight current line

set incsearch
set hlsearch

