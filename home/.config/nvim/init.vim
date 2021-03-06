" Yank to clipboard
set clipboard+=unnamedplus

" Don't apply this stuff in VSCode's Neovim mode.
if !exists('g:vscode')
    " Meta key re-mapping
    inoremap jk <ESC> " Easier escape mode
    let mapleader = "'" " Easier leader

    " File management
    noremap <leader>q :q<cr>
    nnoremap <leader>w :w<cr>
    nnoremap <leader>z :wq<cr>

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

    " Spelling
    nnoremap <leader>s :set spell!<CR>
    set nospell spelllang=en_us

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
    " Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-surround'
    " Plug 'tpope/vim-fugitive'
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
    " Plug 'nathanaelkane/vim-indent-guides'
    " Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
    Plug 'editorconfig/editorconfig-vim'
    Plug 'svermeulen/vim-cutlass'
    " To add when I'm used to the others
    " Plug 'svermeulen/vim-subversive'
    " Plug 'tpope/vim-unimpaired'
    " Plug 'tpope/vim-repeat'
    " Plug 'tpope/vim-sensible'

    call plug#end()

    " Gruvbox
    let g:gruvbox_contrast_dark='hard'
    autocmd vimenter * ++nested colorscheme gruvbox

    " runtime coc.vim

    " Open new splits to right and bottom: apparently more natural than vim's
    " defaults
    set splitbelow
    set splitright

    let g:netrw_banner = 0

else " vscode check

    " Make standard VSCode mappings work
    xmap gc  <Plug>VSCodeCommentary
    nmap gc  <Plug>VSCodeCommentary
    omap gc  <Plug>VSCodeCommentary
    nmap gcc <Plug>VSCodeCommentaryLine

    xmap <C-/> <Plug>VSCodeCommentary
    nmap <C-/> <Plug>VSCodeCommentaryLine

    call plug#begin(stdpath('data') . '/plugged')

    Plug 'tpope/vim-surround'
    Plug 'svermeulen/vim-cutlass'

    call plug#end()

endif " vscode check

" 'Cut' commands, for use with vim-cutlass
nnoremap m d
xnoremap m d
nnoremap mm dd
nnoremap M D

" Easier window navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Scroll up and down with d/e
nnoremap <C-e> <C-u>
