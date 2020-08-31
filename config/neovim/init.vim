set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" load vim-plug for neovim
call plug#begin('~/.config/nvim/plugged')

" Fuzzy finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Project directory tree
Plug 'preservim/nerdtree'

" Initialize plugin system
call plug#end()

