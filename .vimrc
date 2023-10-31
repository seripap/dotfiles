set re=0

call plug#begin()
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'neoclide/coc-tsserver'
"Plug 'neoclide/coc-eslint'
"Plug 'neoclide/coc-json'
" Plug 'neoclide/coc-prettier'
"Plug 'neoclide/coc-css'
"Plug 'neoclide/coc-yaml'
"Plug 'marlonfan/coc-phpls'
"Plug 'fannheyward/coc-styled-components'
"Plug 'josa42/coc-go'
"Plug 'josa42/coc-sh'
"Plug 'fannheyward/coc-pyright'
Plug 'mhartington/oceanic-next'
Plug 'wbthomason/packer.nvim'
Plug 'neovim/nvim-lspconfig'

Plug 'nvim-lualine/lualine.nvim'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'

" yavascript
Plug 'HerringtonDarkholme/yats.vim'

Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'html'] }    
Plug 'leafgarland/typescript-vim'
" Plug 'bigfish/vim-js-context-coloring'
" Plug 'peitalin/vim-jsx-typescript'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'

" Plug 'prettier/vim-prettier'
" Allows fast commenting
Plug 'tpope/vim-commentary'

" Git
Plug 'airblade/vim-gitgutter'
" Plug 'tpope/vim-fugitive'

Plug 'sheerun/vim-polyglot'

" Adds the BD command for split view
Plug 'qpkorr/vim-bufkill'

" Fuzzy search
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'jparise/vim-graphql'

" QoL stuff
Plug 'vim-test/vim-test'
Plug 'alvan/vim-closetag'

" Coverage
Plug 'ruanyl/coverage.vim'

Plug 'dracula/vim', { 'name': 'dracula' }

Plug 'preservim/nerdtree'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'github/copilot.vim'

call plug#end()

" set t_Co=256
set nocompatible
set nofoldenable
filetype off
filetype plugin indent on

set showcmd
set backspace=indent,eol,start

let mapleader = ','

"" Fix for tmux
if exists('$TMUX')
  set background=dark
  set t_Co=256
endif

if has('termguicolors')
  " let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  " let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

"" Colors
" packadd! dracula_pro
" if !exists("g:syntax_on")
"     syntax enable
" endif
" let g:dracula_colorterm = 0
" colorscheme dracula_pro_buffy
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
colorscheme OceanicNext
highlight Normal ctermbg=None

"" Defaults
set encoding=UTF-8
set number
set norelativenumber
set autoindent
set smartindent
set autowrite
set noswapfile
set nobackup
set nowritebackup
set ruler
au FocusLost * :wa
set hidden
set smarttab

"" Ignore
set wildmenu
set wildmode=list:full

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.luac                           " Lua byte code
set wildignore+=migrations                       " Django migrations
set wildignore+=go/pkg                          " Go static files
set wildignore+=go/bin                           " Go bin files
set wildignore+=go/bin-vagrant                   " Go bin-vagrant files
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.orig                           " Merge resolution files
set wildignore+=*/tmp/*,*.so,*.zip,*/node_modules/*,*/vendor/*
 
"" Search
set noshowmode  
set hlsearch
set incsearch
set ignorecase
set showmatch
set ttyfast

"" speed up syntax highlighting
set nocursorcolumn

set tw=500
set tabstop=2
set shiftwidth=2
set wrap
set signcolumn=yes
set cmdheight=2

if &history < 1000
  set history=50
endif

if &tabpagemax < 50
  set tabpagemax=50
endif

if !empty(&viminfo)
  set viminfo^=!
endif

if !&scrolloff
  set scrolloff=1
endif
if !&sidescrolloff
  set sidescrolloff=5
endif

"" Usable width for MD
au BufRead,BufNewFile *.md setlocal textwidth=80

"" vim commentry like st
map <leader>/ gcc

"" nmap <C-P> :Files %:p:h<CR>
nmap <C-p> :Files <CR>
nmap <F8> :TagbarToggle<CR>
nnoremap <Leader>b :ls<CR>:b<Space>
inoremap jj <ESC>
nmap mm :noh<CR>

"" Prettier Settings
" let g:prettier#autoformat_config_present = 1
" let g:prettier#autoformat_require_pragma = 0

" nmap <Leader>py <Plug>(Prettier)

set pastetoggle=<leader>z

"" vsplit
map <leader>] :vsplit<CR>

"" copypasta
noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

"" buffer switch
map <Leader>b :bn<cr>
map <Leader>B :bp<cr>
map <Leader>bb :bd<cr>

"" Better display for messages
"" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
"" don't give |ins-completion-menu| messages.
set shortmess+=c

"set cursorline

""" -------------------------------
"" Plugin settings
""" -------------------------------

"" NERDTree
nmap <leader>q :NERDTreeToggle<cr>

"" GitGutter
" highlight DiffAdd guibg=DraculaGreen
" highlight DiffChange guibg=DraculaOrange 
" highlight DiffDelete guibg=DraculaRed

"" vim-test settings
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
"" Generics
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>

let test#strategy = {
  \ 'nearest': 'neovim',
  \ 'file': 'basic',
  \ 'suite': 'basic',
\}

let test#javascript#jest#executable = "NODE_ENV=test npm test -- -u"
let g:test#javascript#runner = 'jest'

" Use `[c` and `]c` to navigate diagnostics
"nmap <silent> [c <Plug>(coc-diagnostic-prev)
"nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)


" buffer switch
map <Leader>b :bn<cr>
map <Leader>B :bp<cr>
map <Leader>bb :bd<cr>


""" Golang settings
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
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
autocmd FileType go noremap <Leader>d  <Plug>(go-def)

""" Coverage

let g:coverage_json_report_path = 'coverage/coverage-final.json'
"" Define the symbol display for covered lines
let g:coverage_sign_uncovered = '|'

"" Do not display signs on covered lines
let g:coverage_show_covered = 0 

"" Display signs on uncovered lines
let g:coverage_show_uncovered = 1

"" Airline
" let g:airline_theme='dracula'
let g:airline_theme='oceanicnext'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#coc#enabled = 1
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

autocmd BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw  

"nmap <leader>i :CocCommand tsserver.organizeImports<cr>

if has('nvim')
  tmap <C-o> <C-\><C-n>
endif
