
call plug#begin()
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" yavascript
Plug 'leafgarland/typescript-vim'
" For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'

Plug 'nvim-lua/plenary.nvim'
Plug 'mhartington/formatter.nvim'
Plug 'prettier/vim-prettier'
" Allows fast commenting
Plug 'tpope/vim-commentary'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'sheerun/vim-polyglot'

Plug 'nvim-lualine/lualine.nvim'

" Adds the BD command for split view
Plug 'qpkorr/vim-bufkill'

" Fuzzy search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'jparise/vim-graphql'

" QoL stuff
Plug 'vim-test/vim-test'
Plug 'chrisbra/colorizer'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'vim-airline/vim-airline'
Plug 'liuchengxu/vim-which-key'
Plug 'alvan/vim-closetag'

call plug#end()

set t_Co=256
set nocompatible
set nofoldenable
filetype off
filetype plugin indent on

set showcmd
set backspace=indent,eol,start

let mapleader = ','

" Autocomplete
set completeopt=menu,menuone,noselect

" Colors
packadd! dracula_pro

" Fix for tmux
if exists('$TMUX')
  set background=dark
  set t_Co=256
endif

if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

let g:dracula_colorterm = 0
syntax enable
colorscheme dracula_pro

" Airline
let g:airline_theme='dracula_pro'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#nvimlsp#enabled = 1 
let g:airline#extensions#hunks#enabled = 0

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" coc for vim airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" unicode symbols for airline
" Cleans things up a bit...
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


" Defaults
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

" Ignore
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

 
" Search
set noshowmode  
set hlsearch
set incsearch
set ignorecase
set showmatch
set ttyfast

" speed up syntax highlighting
set nocursorcolumn
set nocursorline

set tw=500
set tabstop=4
set shiftwidth=4
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

" Load Lua Configs
lua require('lsp-config')
lua require('lsp-autocomplete')

nmap <C-P> :Files %:p:h<CR>
nmap <C-p> :Files <CR>
nmap <F8> :TagbarToggle<CR>
nnoremap <Leader>b :ls<CR>:b<Space>
inoremap jj <ESC>
nmap mm :noh<CR>

" Prettier Settings
let g:prettier#autoformat_config_present = 1
let g:prettier#autoformat_require_pragma = 0

nmap <Leader>py <Plug>(Prettier)

" Disable Ex mode
"map q: <Nop>
"nnoremap Q <nop>

set pastetoggle=<leader>z

" vim commentry like st
map <leader>/ gcc

" vsplit
map <leader>] :vsplit<CR>

" copypasta
noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

" buffer switch
map <Leader>b :bn<cr>
map <Leader>B :bp<cr>
map <Leader>bb :bd<cr>

" Better display for messages
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c

set cursorline
""autocmd WinEnter * setlocal cursorline
""autocmd WinLeave * setlocal nocursorline

" ============================= vim-which-key ============================
" Setup WhichKey here for our leader.
" TODO: figure out why the timeout doesn't work
nnoremap <silent> <leader> :<c-u>WhichKey ','<CR>
call which_key#register(',', "g:which_key_map")
" Define prefix dictionary
let g:which_key_map =  {}
nnoremap <leader>? :WhichKey ','<CR>
let g:which_key_map['?'] = 'show help'

"" -------------------------------
" Plugin settings
"" -------------------------------

" vim-test settings
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
" Generics
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>

let test#strategy = {
  \ 'nearest': 'neovim',
  \ 'file': 'basic',
  \ 'suite': 'basic',
\}

let test#javascript#jest#executable = "NODE_ENV=test npm test"
let g:test#javascript#runner = 'jest'

"" Pretty colors for completion
" gray
highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
" blue
highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
" light blue
highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
" pink
highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
" front
highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4

" if has('nvim')
" lua << EOF
" require('lualine').setup{
"   options = {
"     theme = 'dracula',
" 	icons_enabled = false
"     },
" 	sections = { lualine_c = { "os.date('%a')", 'data', "require'lsp-status'.status()" } }

"   }
" EOF
" endif

"" Golang settings
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

"call plug#begin('~/.vim/plugged')
"Plug 'bkad/camelcasemotion'
"Plug 'tpope/vim-surround'
"Plug 'majutsushi/tagbar'
"Plug 'AndrewRadev/splitjoin.vim'
"Plug 'puremourning/vimspector'
"Plug 'andrewradev/tagalong.vim'
"Plug 'jparise/vim-graphql'
"Plug 'andymass/vim-matchup'
"Plug 'dense-analysis/ale'
"call plug#end()


"" camelcase jump
"map <C-k> <Plug>CamelCaseMotion_w
"map <leader>k <Plug>CamelCaseMotion_b


" ==================== nvim-tree.lua ====================
noremap <C-a> :NvimTreeToggle<CR>

let g:which_key_map.n = { 'name' : '+file tree' }
noremap <leader>nn :NvimTreeToggle<cr>
" find the current file in the tree
let g:which_key_map.n.n = 'file tree toggle'
noremap <leader>nf :NvimTreeFindFile<cr>
let g:which_key_map.n.f = 'file tree find file'

let g:nvim_tree_add_trailing = 1
let g:nvim_tree_highlight_opened_files = 1
let g:nvim_tree_git_hl = 1

if has('nvim')
lua << EOF
local tree_cb = require'nvim-tree.config'.nvim_tree_callback
vim.g.nvim_tree_show_icons = {
	git = 0,
	folders = 0,
	files = 0,
	folder_arrows = 0,
}

require'nvim-tree'.setup{
  -- Setting this to true breaks :GBrowse & vim-rhubarb.
  disable_netrw = false,
  -- Close nvim-tree and vim on close file
  auto_close = true,
  filters = {
    dotfiles = false,
    custom = {
      '.DS_Store',
    },
    },
git = {
		ignore = 1
	},
  view = {
    mappings = {
      list = {
        { key = "?", cb = tree_cb("toggle_help") },
        -- this annoys me when i think I am saving a file and get an error
        -- so just refresh the tree
        { key = ":w", cb = tree_cb("refresh") },
        -- move the file
        { key = "m", cb = tree_cb("rename") },
        -- refresh the tree
        { key = "r", cb = tree_cb("refresh") },
      }
    }
  }
}
EOF
endif

function! GotoWindow(id)
    :call win_gotoid(a:id)
endfunction
