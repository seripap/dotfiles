
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

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" yavascript
Plug 'leafgarland/typescript-vim'

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
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'jparise/vim-graphql'

" QoL stuff
Plug 'vim-test/vim-test'
Plug 'chrisbra/colorizer'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'liuchengxu/vim-which-key'
Plug 'alvan/vim-closetag'
Plug 'simrat39/symbols-outline.nvim'


" Coverage
Plug 'ruanyl/coverage.vim'

" Better quick fix
Plug 'kevinhwang91/nvim-bqf'

" Bufferline
Plug 'akinsho/bufferline.nvim'

" Github
Plug 'pwntester/octo.nvim'

" Dashboard
Plug 'nvim-telescope/telescope.nvim'

" diff
Plug 'sindrets/diffview.nvim'
call plug#end()

set t_Co=256
set nocompatible
set nofoldenable
filetype off
filetype plugin indent on

set showcmd
set backspace=indent,eol,start

let mapleader = ','

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
colorscheme dracula_pro_buffy

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

" Load Lua Configs
if has('nvim')
lua require('lsp-config')
endif

" nmap <C-P> :Files %:p:h<CR>
" nmap <C-p> :Files <CR>
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

" Use deoplete
let g:deoplete#enable_at_startup = 1

" Enable deoplete for golang
call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })

" ============================= vim-which-key ============================
" Setup WhichKey here for our leader.
" TODO: figure out why the timeout doesn't work
if has('nvim')
nnoremap <silent> <leader> :<c-u>WhichKey ','<CR>
call which_key#register(',', "g:which_key_map")
" Define prefix dictionary
let g:which_key_map =  {}
nnoremap <leader>? :WhichKey ','<CR>
let g:which_key_map['?'] = 'show help'
endif
"" -------------------------------
" Plugin settings
"" -------------------------------

" nvim-cmp

set completeopt=menu,menuone,noselect

if has('nvim')
lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    mapping = {
	["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it. 
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

EOF
endif

" Bufferline

if has('nvim')
lua << EOF
  require("bufferline").setup{
    options = {
show_buffer_icons = false,
show_buffer_close_icons = false,
modified_icon = '*',
diagnostics = "nvim_lsp",
      }
  }
EOF
endif

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


" Prevent term from closing
if has('nvim')
  tmap <C-o> <C-\><C-n>
endif

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
"   lua << EOF
" require('pqf').setup()
" EOF
" endif

if has('nvim')
lua << EOF
local dracula_pro = require'lualine.themes.dracula'

--dracula_pro.normal.c.bg = '#393649'
dracula_pro.replace.a.bg = '#9F70A9'

require('lualine').setup{
  options = {
  	icons_enabled = false,
    theme = dracula_pro,
    section_separators = '',
    component_separators = ''
  },
  sections = {
    lualine_b = {'branch', 'diff'},
    lualine_c = {{'filename', path = 1}},
    lualine_x = { 'diagnostics', 'filetype' }
  },
extensions = { 'nvim-tree'}

  }
EOF
endif

"" Lua Formatting
autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_sync(nil, 100)


"" Golang settings
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


" ==================== nvim-treesitter.lua ====================
if has ('nvim')
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  sync_install = false,

  -- List of parsers to ignore installing
  ignore_install = { "javascript" },

  highlight = {
    enable = true,

    -- list of language that will be disabled
    disable = { "c", "rust" },
    additional_vim_regex_highlighting = false,
  },
}

EOF
endif

" ==================== nvim-tree.lua ====================
if has('nvim')
noremap <leader>a :NvimTreeToggle<CR>


let g:which_key_map.n = { 'name' : '+file tree' }
noremap <leader>nn :NvimTreeToggle<cr>
" find the current file in the tree
let g:which_key_map.n.n = 'file tree toggle'
noremap <leader>nf :NvimTreeFindFile<cr>
let g:which_key_map.n.f = 'file tree find file'

let g:nvim_tree_add_trailing = 1
let g:nvim_tree_highlight_opened_files = 1
let g:nvim_tree_git_hl = 1

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

let g:coverage_json_report_path = 'coverage/coverage-final.json'
" Define the symbol display for covered lines
let g:coverage_sign_uncovered = '|'

" Do not display signs on covered lines
let g:coverage_show_covered = 0 

" Display signs on uncovered lines
let g:coverage_show_uncovered = 1

" =================== dashboard-nvim ========================
let g:dashboard_default_executive ='telescope'

" disable the tabline in the dashboard
autocmd FileType dashboard set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2

" Add a custom dashboard items for GitHub
let g:dashboard_custom_section={
  \ 'gh_pull_requests': {
      \ 'description': ['List pull requests          SPC o p'],
      \ 'command': 'Octo pr list' },
  \ 'gh_issues': {
      \ 'description': ['List issues                 SPC o i'],
      \ 'command': 'Octo issue list' },
  \ 'file_files': {
      \ 'description': ['Find files                  SPC f f'],
      \ 'command': 'Telescope find_files' },
  \ 'live_grep': {
      \ 'description': ['Live grep                   SPC f g'],
      \ 'command': 'Telescope live_grep' },
  \ 'book_marks': {
      \ 'description': ['Jump to bookmarks           SPC f m'],
      \ 'command': 'DashboardJumpMarks' },
      \ }


" ==================== telescope.nvim ====================
if has('nvim')
  let g:which_key_map.f = { 'name' : '+telescope find' }
  nnoremap <leader>ff <cmd>Telescope find_files<CR>
  let g:which_key_map.f.f = 'telescope find files'
  nnoremap <leader>fg <cmd>Telescope live_grep<CR>
  let g:which_key_map.f.g = 'telescope live grep'
  nnoremap <leader>fb <cmd>Telescope buffers<CR>
  let g:which_key_map.f.b = 'telescope buffers'
  nnoremap <leader>fh <cmd>Telescope help_tags<CR>
  let g:which_key_map.f.h = 'telescope help tags'

  " Make Ctrl-p work for telescope since we know those keybindings so well.
  nnoremap <C-p> <cmd>Telescope find_files<CR>
  nnoremap <C-g> <cmd>Telescope live_grep<CR>
  nnoremap <C-b> <cmd>Telescope git_branches<CR>

  if !executable('rg')
    echo "You might want to install ripgrep: https://github.com/BurntSushi/ripgrep#installation"
  endif

  lua << EOF
require('telescope').setup{
  defaults = {
    layout_strategy = "horizontal",
    mappings = {
      i = {
        -- map actions.which_key to ?
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["?"] = "which_key"
      }
    },
    file_ignore_patterns = {
      "^.git/",
      ".DS_Store",
    },
  },
  pickers = {
    find_files = {
      find_command = {"rg", "--ignore", "--hidden", "--files"},
      },
    live_grep = {
      theme = "dropdown",
      },
    buffers = {
      theme = "dropdown",
      },
    git_branches = {
      theme = "dropdown",
      },
  },
  extensions = {
  }
}
EOF
endif

" ================== octo
if has('nvim')
  if !executable('gh')
    echo "You need to install gh: https://cli.github.com"
  endif

lua << EOF
require"octo".setup({
  default_remote = {"upstream", "origin"}; -- order to try remotes
  reaction_viewer_hint_icon = "!";         -- marker for user reactions
  user_icon = ":)";                        -- user icon
  timeline_marker = "~";                   -- timeline marker
  timeline_indent = "2";                   -- timeline indentation
  right_bubble_delimiter = ">";            -- Bubble delimiter
  left_bubble_delimiter = "<";             -- Bubble delimiter
  github_hostname = "";                    -- GitHub Enterprise host
  snippet_context_lines = 4;               -- number or lines around commented lines
  file_panel = {
    size = 10,                             -- changed files panel rows
    use_icons = true                       -- use web-devicons in file panel
  },
  mappings = {
    issue = {
      close_issue = "<space>ic",           -- close issue
      reopen_issue = "<space>io",          -- reopen issue
      list_issues = "<space>il",           -- list open issues on same repo
      reload = "<C-r>",                    -- reload issue
      open_in_browser = "<C-b>",           -- open issue in browser
      copy_url = "<C-y>",                  -- copy url to system clipboard
      add_assignee = "<space>aa",          -- add assignee
      remove_assignee = "<space>ad",       -- remove assignee
      create_label = "<space>lc",          -- create label
      add_label = "<space>la",             -- add label
      remove_label = "<space>ld",          -- remove label
      goto_issue = "<space>gi",            -- navigate to a local repo issue
      add_comment = "<space>ca",           -- add comment
      delete_comment = "<space>cd",        -- delete comment
      next_comment = "]c",                 -- go to next comment
      prev_comment = "[c",                 -- go to previous comment
      react_hooray = "<space>rp",          -- add/remove 🎉 reaction
      react_heart = "<space>rh",           -- add/remove ❤️ reaction
      react_eyes = "<space>re",            -- add/remove 👀 reaction
      react_thumbs_up = "<space>r+",       -- add/remove 👍 reaction
      react_thumbs_down = "<space>r-",     -- add/remove 👎 reaction
      react_rocket = "<space>rr",          -- add/remove 🚀 reaction
      react_laugh = "<space>rl",           -- add/remove 😄 reaction
      react_confused = "<space>rc",        -- add/remove 😕 reaction
    },
    pull_request = {
      checkout_pr = "<space>po",           -- checkout PR
      merge_pr = "<space>pm",              -- merge PR
      list_commits = "<space>pc",          -- list PR commits
      list_changed_files = "<space>pf",    -- list PR changed files
      show_pr_diff = "<space>pd",          -- show PR diff
      add_reviewer = "<space>va",          -- add reviewer
      remove_reviewer = "<space>vd",       -- remove reviewer request
      close_issue = "<space>ic",           -- close PR
      reopen_issue = "<space>io",          -- reopen PR
      list_issues = "<space>il",           -- list open issues on same repo
      reload = "<C-r>",                    -- reload PR
      open_in_browser = "<C-b>",           -- open PR in browser
      copy_url = "<C-y>",                  -- copy url to system clipboard
      add_assignee = "<space>aa",          -- add assignee
      remove_assignee = "<space>ad",       -- remove assignee
      create_label = "<space>lc",          -- create label
      add_label = "<space>la",             -- add label
      remove_label = "<space>ld",          -- remove label
      goto_issue = "<space>gi",            -- navigate to a local repo issue
      add_comment = "<space>ca",           -- add comment
      delete_comment = "<space>cd",        -- delete comment
      next_comment = "]c",                 -- go to next comment
      prev_comment = "[c",                 -- go to previous comment
      react_hooray = "<space>rp",          -- add/remove 🎉 reaction
      react_heart = "<space>rh",           -- add/remove ❤️ reaction
      react_eyes = "<space>re",            -- add/remove 👀 reaction
      react_thumbs_up = "<space>r+",       -- add/remove 👍 reaction
      react_thumbs_down = "<space>r-",     -- add/remove 👎 reaction
      react_rocket = "<space>rr",          -- add/remove 🚀 reaction
      react_laugh = "<space>rl",           -- add/remove 😄 reaction
      react_confused = "<space>rc",        -- add/remove 😕 reaction
    },
    review_thread = {
      goto_issue = "<space>gi",            -- navigate to a local repo issue
      add_comment = "<space>ca",           -- add comment
      add_suggestion = "<space>sa",        -- add suggestion
      delete_comment = "<space>cd",        -- delete comment
      next_comment = "]c",                 -- go to next comment
      prev_comment = "[c",                 -- go to previous comment
      select_next_entry = "]q",            -- move to previous changed file
      select_prev_entry = "[q",            -- move to next changed file
      close_review_tab = "<C-c>",          -- close review tab
      react_hooray = "<space>rp",          -- add/remove 🎉 reaction
      react_heart = "<space>rh",           -- add/remove ❤️ reaction
      react_eyes = "<space>re",            -- add/remove 👀 reaction
      react_thumbs_up = "<space>r+",       -- add/remove 👍 reaction
      react_thumbs_down = "<space>r-",     -- add/remove 👎 reaction
      react_rocket = "<space>rr",          -- add/remove 🚀 reaction
      react_laugh = "<space>rl",           -- add/remove 😄 reaction
      react_confused = "<space>rc",        -- add/remove 😕 reaction
    },
    submit_win = {
      approve_review = "<C-a>",            -- approve review
      comment_review = "<C-m>",            -- comment review
      request_changes = "<C-r>",           -- request changes review
      close_review_tab = "<C-c>",          -- close review tab
    },
    review_diff = {
      add_review_comment = "<space>ca",    -- add a new review comment
      add_review_suggestion = "<space>sa", -- add a new review suggestion
      focus_files = "<leader>e",           -- move focus to changed file panel
      toggle_files = "<leader>b",          -- hide/show changed files panel
      next_thread = "]t",                  -- move to next thread
      prev_thread = "[t",                  -- move to previous thread
      select_next_entry = "]q",            -- move to previous changed file
      select_prev_entry = "[q",            -- move to next changed file
      close_review_tab = "<C-c>",          -- close review tab
      toggle_viewed = "<leader><space>",   -- toggle viewer viewed state
    },
    file_panel = {
      next_entry = "j",                    -- move to next changed file
      prev_entry = "k",                    -- move to previous changed file
      select_entry = "<cr>",               -- show selected changed file diffs
      refresh_files = "R",                 -- refresh changed files panel
      focus_files = "<leader>e",           -- move focus to changed file panel
      toggle_files = "<leader>b",          -- hide/show changed files panel
      select_next_entry = "]q",            -- move to previous changed file
      select_prev_entry = "[q",            -- move to next changed file
      close_review_tab = "<C-c>",          -- close review tab
      toggle_viewed = "<leader><space>",   -- toggle viewer viewed state
    }
  }
})
EOF
endif

"================diffview

if has('nvim')
lua << EOF
local cb = require'diffview.config'.diffview_callback

require'diffview'.setup {
  diff_binaries = false,    -- Show diffs for binaries
  enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
  use_icons = true,         -- Requires nvim-web-devicons
  icons = {                 -- Only applies when use_icons is true.
    folder_closed = "",
    folder_open = "",
  },
  signs = {
    fold_closed = "",
    fold_open = "",
  },
  file_panel = {
    position = "left",                  -- One of 'left', 'right', 'top', 'bottom'
    width = 35,                         -- Only applies when position is 'left' or 'right'
    height = 10,                        -- Only applies when position is 'top' or 'bottom'
    listing_style = "tree",             -- One of 'list' or 'tree'
    tree_options = {                    -- Only applies when listing_style is 'tree'
      flatten_dirs = true,              -- Flatten dirs that only contain one single dir
      folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'.
    },
  },
  file_history_panel = {
    position = "bottom",
    width = 35,
    height = 16,
    log_options = {
      max_count = 256,      -- Limit the number of commits
      follow = false,       -- Follow renames (only for single file)
      all = false,          -- Include all refs under 'refs/' including HEAD
      merges = false,       -- List only merge commits
      no_merges = false,    -- List no merge commits
      reverse = false,      -- List commits in reverse order
    },
  },
  default_args = {    -- Default args prepended to the arg-list for the listed commands
    DiffviewOpen = {},
    DiffviewFileHistory = {},
  },
  hooks = {},         -- See ':h diffview-config-hooks'
  key_bindings = {
    disable_defaults = false,                   -- Disable the default key bindings
    -- The `view` bindings are active in the diff buffers, only when the current
    -- tabpage is a Diffview.
    view = {
      ["<tab>"]      = cb("select_next_entry"),  -- Open the diff for the next file
      ["<s-tab>"]    = cb("select_prev_entry"),  -- Open the diff for the previous file
      ["gf"]         = cb("goto_file"),          -- Open the file in a new split in previous tabpage
      ["<C-w><C-f>"] = cb("goto_file_split"),    -- Open the file in a new split
      ["<C-w>gf"]    = cb("goto_file_tab"),      -- Open the file in a new tabpage
      ["<leader>e"]  = cb("focus_files"),        -- Bring focus to the files panel
      ["<leader>b"]  = cb("toggle_files"),       -- Toggle the files panel.
    },
    file_panel = {
      ["j"]             = cb("next_entry"),           -- Bring the cursor to the next file entry
      ["<down>"]        = cb("next_entry"),
      ["k"]             = cb("prev_entry"),           -- Bring the cursor to the previous file entry.
      ["<up>"]          = cb("prev_entry"),
      ["<cr>"]          = cb("select_entry"),         -- Open the diff for the selected entry.
      ["o"]             = cb("select_entry"),
      ["<2-LeftMouse>"] = cb("select_entry"),
      ["-"]             = cb("toggle_stage_entry"),   -- Stage / unstage the selected entry.
      ["S"]             = cb("stage_all"),            -- Stage all entries.
      ["U"]             = cb("unstage_all"),          -- Unstage all entries.
      ["X"]             = cb("restore_entry"),        -- Restore entry to the state on the left side.
      ["R"]             = cb("refresh_files"),        -- Update stats and entries in the file list.
      ["<tab>"]         = cb("select_next_entry"),
      ["<s-tab>"]       = cb("select_prev_entry"),
      ["gf"]            = cb("goto_file"),
      ["<C-w><C-f>"]    = cb("goto_file_split"),
      ["<C-w>gf"]       = cb("goto_file_tab"),
      ["i"]             = cb("listing_style"),        -- Toggle between 'list' and 'tree' views
      ["f"]             = cb("toggle_flatten_dirs"),  -- Flatten empty subdirectories in tree listing style.
      ["<leader>e"]     = cb("focus_files"),
      ["<leader>b"]     = cb("toggle_files"),
    },
    file_history_panel = {
      ["g!"]            = cb("options"),            -- Open the option panel
      ["<C-A-d>"]       = cb("open_in_diffview"),   -- Open the entry under the cursor in a diffview
      ["y"]             = cb("copy_hash"),          -- Copy the commit hash of the entry under the cursor
      ["zR"]            = cb("open_all_folds"),
      ["zM"]            = cb("close_all_folds"),
      ["j"]             = cb("next_entry"),
      ["<down>"]        = cb("next_entry"),
      ["k"]             = cb("prev_entry"),
      ["<up>"]          = cb("prev_entry"),
      ["<cr>"]          = cb("select_entry"),
      ["o"]             = cb("select_entry"),
      ["<2-LeftMouse>"] = cb("select_entry"),
      ["<tab>"]         = cb("select_next_entry"),
      ["<s-tab>"]       = cb("select_prev_entry"),
      ["gf"]            = cb("goto_file"),
      ["<C-w><C-f>"]    = cb("goto_file_split"),
      ["<C-w>gf"]       = cb("goto_file_tab"),
      ["<leader>e"]     = cb("focus_files"),
      ["<leader>b"]     = cb("toggle_files"),
    },
    option_panel = {
      ["<tab>"] = cb("select"),
      ["q"]     = cb("close"),
    },
  },
}
EOF
endif
