" junegunn/vim-plug config

call plug#begin('~/.vim/bundle')
" This plugin manager
Plug 'junegunn/vim-plug'

Plug 'lifepillar/vim-solarized8'
Plug 'henrik/vim-indexed-search'
Plug 'luochen1990/rainbow'
Plug 'lifepillar/vim-mucomplete'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'

"""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""" Language Specific """""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""
" Ruby
Plug 'vim-ruby/vim-ruby'

" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" JavaScript
Plug 'pangloss/vim-javascript'

" TypeScript
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" SCSS
Plug 'cakebaker/scss-syntax.vim'

"""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#end()

" Solarized Options
"
set termguicolors
set background=dark
"let g:solarized_termcolors = 256
"let g:solarized_termcolors = 16
"let g:solarized_visibility = "high"
"let g:solarized_contrast = "high"
colorscheme solarized8_high
" Set colors for Ubuntu
"se t_Co=256
"se t_Co=16

" Reload ~/.vimrc on change
"
"autocmd! bufwritepost .vimrc source ~/.vimrc

" General Options
"
scriptencoding utf-8
set encoding=utf-8
set number	    " Show line numbers
set ruler	    " Show ruler
"set autoindent	    " Simple autoindentation
set hlsearch        " Highlight search results
set incsearch       " Incremental search
set ignorecase      " Do case insensitive matching
set smartcase	    " Do smart case matching
set showcmd         " Show (partial) command in status line
set showmatch       " Show matching brackets
set history=1000    " Increase history from 20
set visualbell	    " Visual 'beep'
set autoread	    " Automatically reload changed files
"au FocusLost * :wa  " Write all when focus is lost

" Command Mode Tab Completion
"
set wildmenu
set wildmode=list:longest

" Buffer Management
"
set hidden

" Mouse Options
"
set mouse=a
"set ttymouse=xterm2
"set ttymouse=sgr

" Allows Deletion with Backspace
"
set backspace=indent,eol,start

" Turn Off Tool Tips in Mac/GVim
"
if has('gui_running')
  set balloondelay=999999
  set noballooneval
endif

" Allows Cursor Wrapping
"
set whichwrap+=<,>,h,l,[,]

" NerdTree Configuration
"
let NERDTreeIgnore=['\.pyc$', '\.orig$']
noremap <silent> <unique> <Leader>; :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" Swap Files
"
"set noswapfile
set swapfile
set directory=~/.vim_tmp,~/tmp,/var/tmp,/tmp
set backupdir=~/.vim_tmp,~/tmp,/var/tmp,/tmp

" Show Whitepace
"
set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>

" Filetype Configuration
"
filetype plugin indent on
syntax on

" Language Specific Configurations
"
augroup MyLanguageSpecific
    autocmd!
    " Ruby/Rails Key Bindings
    autocmd FileType ruby,ruby-sinatra nnoremap <buffer> <leader>r :!ruby -c %<CR>
    autocmd FileType haml nnoremap <buffer> <leader>r :!haml -c %<CR>
    autocmd FileType sass nnoremap <buffer> <leader>r :!sass -c %<CR>
    autocmd BufNewFile,BufRead *.hive set filetype=sql
    autocmd BufNewFile,BufRead *.sql set filetype=sql
    autocmd BufNewFile,BufRead *.psql set filetype=sql
    autocmd BufNewFile,BufRead *.hamlc set ft=haml

    " Pig Script Syntax
    autocmd BufNewFile,BufRead *.pig set filetype=pig syntax=pig

    " Default spacing for Golang
    autocmd FileType go setlocal shiftwidth=4 tabstop=4 noexpandtab

    " Spacing for shell scripts
    autocmd FileType sh setlocal shiftwidth=4 tabstop=4 expandtab

    " For crontab -e to work with vim
    autocmd filetype crontab setlocal nobackup nowritebackup

    " Highlighting for systemd .service files
    autocmd BufNewFile,BufRead *.service* set ft=systemd
augroup END

" Set 2 space tabs as default (for Ruby, etc.)
" All are overridden by ftplugin/ folder
"
set tabstop=2 shiftwidth=2 expandtab

" Change Tab and Pane Keys
" NOTE: C = Control, M = Option, D = Command
"
":map <S-C-left> :tabprevious<cr>
":map <S-C-right> :tabnext<cr>
":map <S-C-down> :tabnew<cr>
:nmap <C-p> :tabprevious<cr>
:nmap <C-n> :tabnext<cr>
":nmap <C-t> :tabnew<cr>
"nmap <Left> :tabp<CR>
"nmap <Right> :tabn<CR>
"nmap <Up> :bp<CR>
"nmap <Down> :bn<CR>
"nnoremap <C-h> <C-w>h
"nnoremap <C-j> <C-w>j
"nnoremap <C-k> <C-w>k
"nnoremap <C-l> <C-w>l

" Set Vim Clipboard to System
"
set clipboard=unnamedplus

" Highlight over 80 characters
"
"highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"match OverLength /\%81v.\+/
set colorcolumn=80
"highlight ColorColumn ctermbg=green guibg=green
"set columns=80


"hi Visual term=reverse cterm=reverse guibg=Grey ctermbg=Grey
"hi Visual guibg=White
"
hi Visual term=reverse cterm=reverse guibg=White ctermbg=White


" Change cursor shape Gnome Terminal 3.x
"
if !has('nvim')
    let &t_SI = "\<Esc>[6 q"
    let &t_SR = "\<Esc>[4 q"
    let &t_EI = "\<Esc>[2 q"
endif

" Rainbow parentheses
"
let g:rainbow_active = 1

" Show trailing whitepace and spaces before a tab:
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/
"highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
"highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen


"Automatically remove trailing whitespace
"
autocmd BufWritePre * :%s/\s\+$//e

" For editing large data files
set synmaxcol=500
set maxmempattern=2000
set redrawtime=2000
