set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" Vim Script
colorscheme NeoSolarized
hi StatusLine guibg=White ctermfg=15 guifg=Black ctermbg=0
hi StatusLineNC guibg=Black ctermfg=0 guifg=White ctermbg=15
