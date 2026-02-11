set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" Vim Script
colorscheme NeoSolarized
hi StatusLine guibg=#586e75 guifg=#002b36 ctermbg=0 ctermfg=7
hi StatusLineNC guibg=#002b36 guifg=#586e75 ctermbg=7 ctermfg=0
