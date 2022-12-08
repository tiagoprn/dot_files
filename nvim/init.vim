" --- MAIN SETTINGS
"
" Rebind <Leader> key
map <SPACE> <leader>

syntax on

set title
set history=1000         " remember more commands and search history

"persistent undo
set undodir=~/.config/nvim/undodir
set undofile

set wildignore=*.swp,*.bak,*.pyc,*~

set relativenumber  " Changing the ruler position
set number  " show line numbers
" set winwidth=80  "minimum window width

set formatoptions+=j  " Remove comment leader when joining comment lines

" When the cursor moves outside the viewport of the current window, the buffer scrolls a single
" line to keep the cursor in view. Setting the option below will start the scrolling x lines
" before the border, keeping more context around where you’re working.
set scrolloff=3

" Change the sound beep on errors to screen flashing
set visualbell

" Height of the command bar
set cmdheight=1

" default updatetime 4000ms is not good for async update
set updatetime=100

" use linux's default gui clipboard - disabled because I have specific mappings for that
" set clipboard=unnamedplus

" Disable backup and swap files - they trigger too many events
" for file system watchers
set nobackup
set nowritebackup
set noswapfile

" Better Searching
set hlsearch             " highlight searches
set incsearch            " show search matches while you type
set ignorecase           " ignore case on searching by default
set smartcase            " uppercase characters will be taken into account

set listchars=tab:→␣,space:·,nbsp:␣,trail:•,eol:↩,precedes:«,extends:»

set completeopt=menu,menuone,noselect

" Enable true colors theme support
set termguicolors

" Cursor to stay in the middle line of the screen when possible:
" set so=999

" Avoids updating the screen before commands are completed
set lazyredraw

" OVERRIDING COLORS
" do that here: lua/catppuccin-colors.lua

" Highlight current line
set cursorline
hi cursorline cterm=none term=none
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
highlight CursorLine guibg=#c0c0c0 ctermbg=238

" Highlight current column
set cursorcolumn
hi cursorcolumn cterm=none term=none
autocmd WinEnter * setlocal cursorcolumn
autocmd WinLeave * setlocal nocursorcolumn
highlight CursorColumn guibg=#303000 ctermbg=238

" --- Configure rg integration
set grepprg=rg\ --vimgrep
set grepformat^=%f:%l:%c:%m

" custom winbar
" right size, file has changed, file path
set winbar=%=%m\ %F

" --- Splits defaults
" open vertical splits on the right side
set splitright
" open horizontal splits below
set splitbelow

" --- setup python virtualenv that has nvim requirements installed - check this repository README.md for details
let g:python3_host_prog = '~/.pyenv/versions/neovim/bin/python'

" --- LUA CONFIGURATION
" must be here, otherwise does not start with nvim
lua << EOF
vim.notify = require("notify")
vim.notify.setup({
	background_colour = "#000000",
	fps = 60,
	timeout = 90,
	top_down=false,
	stages="fade", -- slide, fade, fade_in_slide_out, static
	render="minimal",  -- minimal, simple, default
})
EOF

" --- OTHER SETTINGS

source $HOME/.config/nvim/functions.vim
source $HOME/.config/nvim/commands.vim
source $HOME/.config/nvim/abbreviations.vim
source $HOME/.config/nvim/hooks.vim

source $HOME/.config/nvim/mappings-core.vim
source $HOME/.config/nvim/mappings-commands.vim
source $HOME/.config/nvim/mappings-functions.vim

" --- PLUGINS

lua require('plugins')
lua require('surround-conf')
lua require('nvim-cmp')
lua require('cmp-path-conf')
lua require('lua-lsp')
lua require('python-lsp')
lua require('bash-lsp')
lua require('lsp-signature-conf')
lua require('lsp-saga')
lua require('setup-null-ls')
lua require('treesitter-conf')
lua require('tree')
lua require('catppuccin-colors')
lua require('autopairs')
lua require('snippets')
lua require('aerial-code-navigation')
lua require('telescope-conf')
lua require('sessions')
lua require('gitsigns-conf')
lua require('lualine-conf')
lua require('toggleterm-conf')
lua require('comment-conf')
lua require('highlight-colors-conf')
lua require('lsp-colors-conf')
lua require('trouble-conf')
lua require('zen-conf')
lua require('easypick-conf')
lua require('treesitter-context-conf')
lua require('harpoon-conf')
lua require('smooth-cursor-conf')
lua require('dressing-conf')
lua require('hydra-conf')
lua require('svart-conf')
lua require('buffer_manager-conf')

source $HOME/.config/nvim/conf-plugins/marvim.vim
source $HOME/.config/nvim/conf-plugins/conceals.vim
source $HOME/.config/nvim/conf-plugins/navigator.vim
source $HOME/.config/nvim/conf-plugins/asyncrun.vim
source $HOME/.config/nvim/mappings-plugins.vim

source $HOME/.config/nvim/commands-tiagoprn-functions.vim
source $HOME/.config/nvim/mappings-tiagoprn-functions.vim

" AUTOGROUPS
"" Below overrides MAIN SETTINGS section configuration, according to the file type
source $HOME/.config/nvim/augroups/python.vim
source $HOME/.config/nvim/augroups/lua.vim
source $HOME/.config/nvim/augroups/quickfix.vim
source $HOME/.config/nvim/augroups/text.vim
source $HOME/.config/nvim/augroups/json.vim
source $HOME/.config/nvim/augroups/misc.vim
source $HOME/.config/nvim/augroups/completion.vim
source $HOME/.config/nvim/augroups/html.vim

