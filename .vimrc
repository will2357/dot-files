" junegunn/vim-plug config
"
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
Plug 'ajh17/VimCompletesMe'
Plug 'altercation/vim-colors-solarized'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'dragfire/Improved-Syntax-Highlighting-Vim'
Plug 'henrik/vim-indexed-search'
Plug 'junegunn/vim-plug'
Plug 'kien/rainbow_parentheses.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'

" Clojure
Plug 'guns/vim-clojure-highlight' "Requires tpope/vim-fireplace
Plug 'tpope/vim-fireplace'
Plug 'guns/vim-clojure-static'

" S-expressions
Plug 'guns/vim-sexp' "Soooo much faster
call plug#end()

" Filetype Configuration
"
syntax on
filetype on
filetype plugin on
filetype indent on

" Solarized Options
"
set background=dark
let g:solarized_termcolors = 256
"let g:solarized_termcolors = 16
"let g:solarized_visibility = "high"
"let g:solarized_contrast = "high"
colorscheme solarized

" Set colors for Ubuntu
"se t_Co=256
"se t_Co=16

" Reload ~/.vimrc on Change
"
autocmd! bufwritepost .vimrc source ~/.vimrc

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

" Allows Deletion with Backspace
"
set backspace=2

" Turn Off Tool Tips in Mac/GVim
"
if has('gui_running')
  set balloondelay=999999
  set noballooneval
endif

" Set 2 Space Tabs for Ruby
" Overridden by FTPlugins
"
set tabstop=2 shiftwidth=2 expandtab

" Cursor Options for Mac/GVim
"
"highlight Cursor guifg=white guibg=black
"highlight iCursor guifg=white guibg=red
"set guicursor=n-v-c:block-Cursor
"set guicursor+=i:ver25-iCursor
"set guicursor+=n-v-c:blinkon0
"set guicursor+=i:blinkwait10

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
set backupdir=~/.vim_tmp,/var/tmp,/tmp
set directory=~/.vim_tmp,/var/tmp,/tmp

" Show Whitepace
"
set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>

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

" Tagbar Toggle
"
nmap <leader>t :TagbarToggle<CR>
" Change Tab and Pane Keys
" Note: C = Control, M = Option, D = Command
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
set clipboard=unnamed

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
highlight ColorColumn ctermbg=green guibg=green
"set columns=80

"hi Visual term=reverse cterm=reverse guibg=Grey ctermbg=Grey
"hi Visual guibg=White
hi Visual term=reverse cterm=reverse guibg=White ctermbg=White

" Change cursor shape
" tmux will only forward escape sequences to the terminal if surrounded by a DCS sequence
" http://sourceforge.net/mailarchive/forum.php?thread_name=AANLkTinkbdoZ8eNR1X2UobLTeww1jFrvfJxTMfKSq-L%2B%40mail.gmail.com&forum_name=tmux-users
"
"if exists('$TMUX')
  "let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  "let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
"else
  "let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  "let &t_EI = "\<Esc>]50;CursorShape=0\x7"
"endif

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

" Alternate Rainbow Parentheses
"let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

" Indentation support for Midje with vim-clojure-static
let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let', '^facts', '^fact', '^go', '^go-loop']

" Indentation for absurd Clojure style guide with vim-clojure-static
let g:clojure_align_subforms = 1
let g:clojure_align_multiline_strings = 1

" Tmux conf for vim-slime
let g:slime_target = "tmux"

" Show trailing whitepace and spaces before a tab:
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/
"highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
"highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen


"autocomplete Parenthesis
"When you type an open brace, this will automatically
"insert a closing brace on the same line, after the cursor.
"If you quickly hit Enter after the open brace, (to begin
"a code block), the closing brace will be inserted on the
"line below the cursor. If you quickly press the open brace
"key again after the open brace, Vim won't insert anything extra,
" you'll just get a single open brace. Finally, if you quickly
"type an open and close brace, Vim will not do anything special.
"inoremap {      {}<Left>
"inoremap {<CR>  {<CR>}<Esc>O
"inoremap {{     {
"inoremap {}     {}

"inoremap (      ()<Left>
"inoremap (<CR>  (<CR>)<Esc>O
"inoremap ((     (
"inoremap ()     ()

"inoremap [      []<Left>
"inoremap [<CR>  [<CR>]<Esc>O
"inoremap [[     [
"inoremap []     []

"Automatically remove trailing whitespace
"
autocmd BufWritePre * :%s/\s\+$//e

"For crontab -e to work with vim
"
autocmd filetype crontab setlocal nobackup nowritebackup

"For editing large data files
"
set synmaxcol=120
