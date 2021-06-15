packloadall
syntax on

let mapleader = ','

filetype plugin indent on

" Disable Ex mode
map q: <Nop>
nnoremap Q <nop>

set encoding=UTF-8
set autoindent
set autowrite
set noswapfile
set hlsearch
set incsearch
set ignorecase
set re=0

set nu
set tw=500
set tabstop=4
set shiftwidth=4
set wrap

set mouse=
set ttymouse=
set pastetoggle=<leader>z

set rtp+=/usr/local/bin/fzf

nmap ,n :NERDTreeFind<CR>
nmap <C-p> :Files %:p:h<CR>
nmap <F8> :TagbarToggle<CR>
nnoremap <Leader>b :ls<CR>:b<Space>
inoremap jj <ESC>

" copypasta
noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

"autocmd VimEnter * NERDTree

" Golang settings
let g:go_highlight_operators = 1
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"
let g:go_def_mapping_enabled = 0
let g:go_auto_type_info = 1
let g:go_auto_sameids = 1
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
let g:go_fmt_experimental = 1
let g:go_metalinter_autosave=1
let g:go_metalinter_autosave_enabled=['golint', 'govet']
"autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go noremap <F5> :GoDebugStart
autocmd FileType go noremap <Leader>b :GoDebugBreakpoint<CR>
autocmd FileType go noremap <Leader>n :GoDebugContinue<CR>

noremap <leader>d :NERDTreeToggle<CR>
noremap <leader>f :NerdTreeFind<CR>

" Vim Plugins
call plug#begin('~/.vim/plugged')
Plug 'junegunn/vim-easy-align'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc.nvim'
Plug 'neoclide/coc-tsserver'
Plug 'neoclide/coc-eslint'
Plug 'neoclide/coc-json'
Plug 'neoclide/coc-prettier'
Plug 'neoclide/coc-css'
Plug 'josa42/coc-go'
Plug 'josa42/coc-sh'
Plug 'preservim/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'arzg/vim-colors-xcode'
Plug 'vim-airline/vim-airline-themes'
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'prettier/vim-prettier', {'do': 'yarn install', 'for': ['javascript', 'typescript', 'css', 'scss', 'json', 'graphql', 'markdown', 'yaml', 'html'] }
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/syntastic'
Plug 'majutsushi/tagbar'
call plug#end()

let g:ackprg = 'ag --nogroup --nocolor --column'
let g:syntastic_go_checkers = ['govet', 'errcheck', 'go']

" coc-tsserver
let g:coc_global_extensions = [ 'coc-tsserver' ]


" coc.nvim default settings
" -------------------------------------------------------------------------------------------------

" if hidden is not set, TextEdit might fail.
set hidden
" Better display for messages
set cmdheight=2
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use U to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" GitGutter
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1

" Theme modify
colorscheme xcodedarkhc
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#coc#enabled = 0

let g:airline_theme='luna'
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = ' Line '
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.maxlinenr = ' '
let g:airline_symbols.colnr = "Col "

" Shortcut for view jumping
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Map ctrl+wsad to arrows for 60% keyboard
map <C-a> h
map <C-s> j
map <C-w> k
map <C-d> l
