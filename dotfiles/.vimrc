
syntax enable
au BufRead,BufNewFile *.cap setf ruby
au BufRead,BufNewFile *.haml setf ruby
au BufRead,BufNewFile *.md setf mkd
au BufRead,BufNewFile *.pp setf puppet
au BufRead,BufNewFile *.ru setf ruby
au BufRead,BufNewFile *.scala setf scala
au BufRead,BufNewFile *.textile setf textile
au BufRead,BufNewFile Capfile setf ruby

" Search
set showmatch
set ignorecase  " Ignores the case for search
set incsearch   " Incremental search
set smartcase   " Will only search on case sensitive when upcase is used

:hi Search guibg=LightBlue
:hi Search ctermbg=LightGrey

" Tab stop and indent stuff
set ts=2
set tabstop=2
set expandtab
set shiftwidth=2

set autoindent
set smartindent

" Line numbers
set ruler
set number
:hi LineNr ctermfg=LightGrey

" Misc
set wildignore=*.o
set wildmenu
set nocp
set backspace=indent,eol,start
set laststatus=2
set noeol

" Other useful tips: http://items.sjbach.com/319/configuring-vim-right
set hidden
set history=1000
set so=2

nnoremap ' `
nnoremap ` '

let mapleader="`"

" Toggle highlight search with F10
map <Leader>hh :set hlsearch!<CR>
imap <Leader>hh <ESC>:set hlsearch!<CR>a

" Shortcuts to move between buffers
if has("gui_macvim")
  map :e :tabnew
  map [ :tabprev<cr>
  map ] :tabnext<cr>
else
  map [ :bp<cr>
  map ] :bn<cr>
end

" Automatically close curly brace on enter
inoremap {<CR>  {<CR>}<Esc>O

