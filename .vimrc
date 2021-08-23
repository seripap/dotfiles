packloadall
set rtp+=~/.vim
syntax on

hi Search ctermfg=Red cterm=bold

let mapleader = ','

set nocompatible
filetype plugin indent on
runtime macros/matchit.vim

" Disable Ex mode
map q: <Nop>
nnoremap Q <nop>

set history=10000
set encoding=UTF-8
set autoindent
set smartindent
set autowrite
set noswapfile
set hlsearch
set incsearch
set ignorecase
set showmatch
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*,*/vendor/*
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

nmap <C-P> :Files %:p:h<CR>
nmap <C-p> :Files <CR>
nmap <F8> :TagbarToggle<CR>
nnoremap <Leader>b :ls<CR>:b<Space>
inoremap jj <ESC>
nmap mm :noh<CR>

" vim commentry like st
map <leader>/ gcc

" vsplit
map <leader>] :vsplit<CR>

" copypasta
noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

" highlight current line
set cursorline
hi cursorline cterm=none term=none
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
highlight CursorLine guibg=#e4e4e4 ctermbg=254

" For tagalong
inoremap <silent> <c-c> <c-c>:call tagalong#Apply()<cr>

"autocmd VimEnter * NERDTree

" Golang settings
let g:go_addtags_transform = "camelcase"
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
let g:go_metalinter_autosave_enabled=['golint', 'govet', 'errcheck']
"autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go noremap <F5> :GoDebugStart
autocmd FileType go noremap <Leader>b :GoDebugBreakpoint<CR>
autocmd FileType go noremap <Leader>n :GoDebugContinue<CR>

noremap <leader>d :NERDTreeToggle<CR>
noremap <leader>f :NERDTreeFind<CR>
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" Plugins
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
Plug 'fannheyward/coc-styled-components'
Plug 'josa42/coc-go'
Plug 'josa42/coc-sh'
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline-themes'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'sheerun/vim-polyglot'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'qpkorr/vim-bufkill'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/syntastic'
Plug 'majutsushi/tagbar'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'
Plug 'andrewradev/tagalong.vim'
call plug#end()

let g:ackprg = 'ag --nogroup --nocolor --column'
let g:syntastic_go_checkers = ['govet', 'errcheck', 'go']

" coc-tsserver
let g:coc_global_extensions = [ 'coc-tsserver' ]
" coc-settings
let g:coc_global_config="/Users/dseripap/dotfiles/coc-settings.json"

" Tagbar
let g:tagbar_type_typescriptreact = {
\ 'ctagstype': 'typescript',
\ 'kinds': [
  \ 'c:class',
  \ 'n:namespace',
  \ 'f:function',
  \ 'G:generator',
  \ 'v:variable',
  \ 'm:method',
  \ 'p:property',
  \ 'i:interface',
  \ 'g:enum',
  \ 't:type',
  \ 'a:alias',
\ ],
\'sro': '.',
  \ 'kind2scope' : {
  \ 'c' : 'class',
  \ 'n' : 'namespace',
  \ 'i' : 'interface',
  \ 'f' : 'function',
  \ 'G' : 'generator',
  \ 'm' : 'method',
  \ 'p' : 'property',
  \},
\ }

" Prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile
nmap <Leader>py <Plug>(Prettier)

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

" coc for vim airline
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" buffer switch
map <Leader>b :bn<cr>
map <Leader>B :bp<cr>
map <Leader>bb :bd<cr>

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
if has('termguicolors')
set termguicolors 
endif

" colorscheme 
let g:dracula_italic = 0
let g:dracula_colorterm = 0
colorscheme dracula
hi Comment guifg=#5f5f5f ctermfg=59


let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#coc#enabled = 1
let g:airline_theme='dracula'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = ' '
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.maxlinenr = ' '
let g:airline_symbols.colnr = "c."

" Shortcut for view jumping
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"nnoremap <C-Left> :tabprevious<CR>
"nnoremap <C-Right> :tabnext<CR>
"nnoremap <C-j> :tabprevious<CR>
"nnoremap <C-k> :tabnext<CR>

" Shift+directions to move lines
nnoremap <S-Up> :m-2<CR>
nnoremap <S-Down> :m+<CR>
inoremap <S-Up> <Esc>:m-2<CR>
inoremap <S-Down> <Esc>:m+<CR>

" o/O                   Start insert mode with [count] blank lines.
"                       The default behavior repeats the insertion [count]
"                       times, which is not so useful.
"                       OG: https://stackoverflow.com/questions/27819225/inserting-two-new-lines-in-vim
function! s:NewLineInsertExpr( isUndoCount, command )
    if ! v:count
        return a:command
    endif

    let l:reverse = { 'o': 'O', 'O' : 'o' }
    " First insert a temporary '$' marker at the next line (which is necessary
    " to keep the indent from the current line), then insert <count> empty lines
    " in between. Finally, go back to the previously inserted temporary '$' and
    " enter insert mode by substituting this character.
    " Note: <C-\><C-n> prevents a move back into insert mode when triggered via
    " |i_CTRL-O|.
    return (a:isUndoCount && v:count ? "\<C-\>\<C-n>" : '') .
    \   a:command . "$\<Esc>m`" .
    \   v:count . l:reverse[a:command] . "\<Esc>" .
    \   'g``"_s'
endfunction
nnoremap <silent> <expr> o <SID>NewLineInsertExpr(1, 'o')
nnoremap <silent> <expr> O <SID>NewLineInsertExpr(1, 'O')

function! GotoWindow(id)
    :call win_gotoid(a:id)
endfunction

" debugger
nnoremap <F5> :call vimspector#Launch()<CR>
nnoremap <leader><F5> :call vimspector#Reset()<CR>
nnoremap <leader>dc :call GotoWindow(g:vimspector_session_windows.code)<CR>
nnoremap <leader>dt :call GotoWindow(g:vimspector_session_windows.tagpage)<CR>
nnoremap <leader>dv :call GotoWindow(g:vimspector_session_windows.variables)<CR>
nnoremap <leader>dw :call GotoWindow(g:vimspector_session_windows.watches)<CR>
nnoremap <leader>ds :call GotoWindow(g:vimspector_session_windows.stack_trace)<CR>
nnoremap <leader>do :call GotoWindow(g:vimspector_session_windows.output)<CR>

noremap <leader>BB :call vimspector#ToggleBreakpoint()<CR>

nmap <leader>dl <Plug>VimspectorStepInto
nmap <leader>dj <Plug>VimspectorStepOver
nmap <leader>dk <Plug>VimspectorStepOut
nmap <leader>d_ <Plug>VimspectorRestart
" Highlight cursor
nnoremap <C-K> :call HighlightNearCursor()<CR>
function HighlightNearCursor()
  if !exists("s:highlightcursor")
    match Todo /\k*\%#\k*/
    let s:highlightcursor=1
  else
    match None
    unlet s:highlightcursor
  endif
endfunction
