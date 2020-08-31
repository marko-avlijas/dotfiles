set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" load vim-plug for neovim
call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Initialize plugin system
call plug#end()

