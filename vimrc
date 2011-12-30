" junegunn/vim-plug config

call plug#begin('~/.vim/bundle')
" This plugin manager
Plug 'junegunn/vim-plug'

Plug 'altercation/vim-colors-solarized'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'cakebaker/scss-syntax.vim'
Plug 'dragfire/Improved-Syntax-Highlighting-Vim'
Plug 'henrik/vim-indexed-search'
Plug 'kien/rainbow_parentheses.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/VimCompletesMe'

" Python
Plug 'Vimjas/vim-python-pep8-indent'

" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

" Solarized Options
"
set background=dark
"let g:solarized_termcolors = 256
"let g:solarized_termcolors = 16
"let g:solarized_visibility = "high"
"let g:solarized_contrast = "high"
colorscheme solarized

" Set colors for Ubuntu
"se t_Co=256
"se t_Co=16

" Reload ~/.vimrc on change
"
"autocmd! bufwritepost .vimrc source ~/.vimrc

" General Options
"
set number	    " Show line numbers
set ruler	    " Show ruler
"set autoindent	    " Simple autoindentation
set cindent	    " Smarter autoindentation - C standard
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
set ttymouse=sgr

" Allows Deletion with Backspace
"
set backspace=2

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

" Swap Files
"
"set noswapfile
set swapfile
set dir=~/.vim_tmp,~/tmp,/var/tmp,/tmp
set backupdir=~/.vim_tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim_tmp,~/tmp,/var/tmp,/tmp

" Show Whitepace
"
set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>

" Filetype Configuration
"
syntax on
filetype on
filetype plugin on
filetype indent on
filetype detect

" Powder Key Bindings
"
au FileType ruby,ruby-sinatra,haml,sass,html,css map <leader>p :!powder restart<cr>
au FileType ruby,ruby-sinatra,haml,sass,html,css map <leader>o :!powder open<cr>

" Ruby/Rails Key Bindings
"
au FileType ruby,ruby-sinatra map <leader>r :!ruby -c %<cr>
au FileType haml map <leader>r :!haml -c %<cr>
au FileType sass map <leader>r :!sass -c %<cr>
au BufNewFile,BufRead *.hive set filetype=sql
au BufNewFile,BufRead *.sql set filetype=sql
au BufNewFile,BufRead *.psql set filetype=sql
au BufNewFile,BufRead *.hamlc set ft=haml

" Pig Script Syntax
"
augroup filetypedetect
  au BufNewFile,BufRead *.pig set filetype=pig syntax=pig
augroup END

" Set 2 space tabs as default (for Ruby, etc.)
" All are overridden by ftplugin/ folder
"
set tabstop=2 shiftwidth=2 expandtab

" Default spacing for Golang
"
autocmd FileType go setlocal shiftwidth=4 tabstop=4 noexpandtab

" Spacing for shell scripts
"
autocmd FileType sh setlocal shiftwidth=4 tabstop=4 expandtab

"For crontab -e to work with vim
"
autocmd filetype crontab setlocal nobackup nowritebackup


" Tagbar Toggle
"
nmap <leader>t :TagbarToggle<CR>
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

" Code Folding Settings
"
"set foldmethod=indent   "fold based on indent
"set foldnestmax=10      "deepest fold is 10 levels
"set nofoldenable        "dont fold by default
"set foldlevel=1         "this is just what i use
set nofoldenable        "disable folding


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
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" Rainbow parentheses
"
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" Tmux conf for vim-slime
let g:slime_target = "tmux"

" Show trailing whitepace and spaces before a tab:
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/
"highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
"highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen


"Automatically remove trailing whitespace
"
autocmd BufWritePre * :%s/\s\+$//e

"Neo Completeion with Cache for Scala autocomplete
"
let g:neocomplcache_enable_at_startup = 1

"For editing large data files
"
set synmaxcol=160
