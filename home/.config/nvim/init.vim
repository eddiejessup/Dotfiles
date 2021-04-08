" Yank to clipboard
set clipboard+=unnamedplus

let mapleader = "'" " Easier leader

inoremap <CR> <Esc>
" nnoremap <SPACE> :w<cr>

" Don't apply this stuff in VSCode's Neovim mode.
if !exists('g:vscode')

    " File management
    noremap <leader>q :q<cr>
    nnoremap <leader>z :wq<cr>

     " Easier escape mode<Nop>
    inoremap jk <ESC>
    inoremap jj <ESC>
     " Avoid bad habit
    inoremap <ESC> <Nop>

    " Display
    syntax on " Highlight syntax
    set number " Show line numbers
    set guicursor+=n:hor20-Cursor/lCursor
    set termguicolors

    " Technical
    set noswapfile " Disable the swapfile
    " Reduce time before writing the swap file. (This also controls the 
    " time before gitgutter refreshes its display: I'm mainly changing 
    " it on that plugin's recommendation.)
    set updatetime=100 

    " Search
    set hlsearch " Highlight all results
    set incsearch " Show search results as you type
    set smartcase " Use case-sensitive search if the pattern contains uppercase. 
    set mouse=a
    " <C-l> normally redraws the screen. Prepend 'nohlsearch' to clear the
    " highlighted search results.
    nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

    " Haskell
    let g:haskell_enable_quantification = 1   " Enable highlighting of `forall`
    let g:haskell_enable_recursivedo = 1      " Enable highlighting of `mdo` and `rec`
    let g:haskell_enable_arrowsyntax = 1      " Enable highlighting of `proc`
    let g:haskell_enable_pattern_synonyms = 1 " Enable highlighting of `pattern`
    let g:haskell_enable_typeroles = 1        " Enable highlighting of type roles
    let g:haskell_enable_static_pointers = 1  " Enable highlighting of `static`
    let g:haskell_backpack = 1                " Enable highlighting of backpack keywords

    " Tabs, spaces and indentation
    set softtabstop=0
    set expandtab
    set smarttab
    set shiftwidth=4

    " New key maps

    "" Vim Config
    nnoremap <leader>c :edit $MYVIMRC<CR> " Edit vimrc
    nnoremap <leader>r :source $MYVIMRC<CR> " Refresh vimrc

    "" Visual mode
    vnoremap . :norm.<CR> " Dot to apply dot line-wise

    call plug#begin(stdpath('data') . '/plugged')

    Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    Plug 'morhetz/gruvbox'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-surround'
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'svermeulen/vim-cutlass'
    " To add when I'm used to the others
    " Plug 'tpope/vim-fugitive'
    " Plug 'svermeulen/vim-subversive'
    " Plug 'tpope/vim-unimpaired'
    " Plug 'tpope/vim-repeat'
    " Plug 'tpope/vim-sensible'
    Plug 'easymotion/vim-easymotion'

    call plug#end()

    " Gruvbox
    let g:gruvbox_contrast_dark='hard'
    autocmd vimenter * ++nested colorscheme gruvbox

    " Open new splits to right and bottom: apparently more natural than vim's
    " defaults
    set splitbelow
    set splitright

    " let g:netrw_banner = 0

else " vscode check

    " Make standard VSCode mappings work
    xmap gc  <Plug>VSCodeCommentary
    nmap gc  <Plug>VSCodeCommentary
    omap gc  <Plug>VSCodeCommentary
    nmap gcc <Plug>VSCodeCommentaryLine

    xmap <C-/> <Plug>VSCodeCommentary
    nmap <C-/> <Plug>VSCodeCommentaryLine

    nnoremap <C-h> <Cmd>call VSCodeNotify('workbench.action.focusLeftGroup')<CR>
    xnoremap <C-h> <Cmd>call VSCodeNotify('workbench.action.focusLeftGroup')<CR>
    nnoremap <C-l> <Cmd>call VSCodeNotify('workbench.action.focusRightGroup')<CR>
    xnoremap <C-l> <Cmd>call VSCodeNotify('workbench.action.focusRightGroup')<CR>

    call plug#begin(stdpath('data') . '/plugged')

    Plug 'tpope/vim-surround'
    Plug 'svermeulen/vim-cutlass'
    " Only forked because vim-plug doesn't like multiple repos with the same
    " name.
    Plug 'eddiejessup/vim-easymotion-vscode'

    call plug#end()

endif " vscode check

" Configure easy-motion.
let g:EasyMotion_do_mapping = 0 " Disable default mappings
" nmap s <Plug>(easymotion-f)
nmap s <Plug>(easymotion-f2)
" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1
" JK motions: Line motions
map <Leader>j <Plug>(easymotion-bd-jk)
" map <Leader>j <Plug>(easymotion-bd-j)
" map <Leader>k <Plug>(easymotion-k)
map <Leader>w <Plug>(easymotion-bd-w)
map <Leader>b <Plug>(easymotion-b)

" Scroll up and down with d/e
nnoremap <C-e> <C-u>
nnoremap <C-k> <S-{>
nnoremap <C-j> <S-}>
" Unmap brace, to avoid the habit.
nnoremap { <Nop>
nnoremap } <Nop>

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" 'Cut' commands, for use with vim-cutlass
nnoremap m d
xnoremap m d
nnoremap mm dd
nnoremap M D
