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

set completeopt=menuone,noselect

" OVERRIDING COLORS
" Overriding color of special chars
" highlight SpecialKey ctermfg=red guifg=red
" Overriding color of the line numbers
highlight LineNr ctermbg=black ctermfg=white
" Overriding color of the status line
" highlight StatusLine ctermbg=black ctermfg=darkblue
" Overriding color of the popup menu

" Below overrides some settings on this section, according to the file type
source $HOME/.config/nvim/augroups/python.vim
source $HOME/.config/nvim/augroups/lua.vim
source $HOME/.config/nvim/augroups/quickfix.vim
source $HOME/.config/nvim/augroups/text.vim
source $HOME/.config/nvim/augroups/misc.vim

" Other

source $HOME/.config/nvim/functions.vim
source $HOME/.config/nvim/commands.vim
source $HOME/.config/nvim/abbreviations.vim
source $HOME/.config/nvim/hooks.vim

source $HOME/.config/nvim/mappings-core.vim
source $HOME/.config/nvim/mappings-shellscripts.vim
source $HOME/.config/nvim/mappings-commands.vim
source $HOME/.config/nvim/mappings-functions.vim

lua require('plugins')
lua require('lsp-compe-config')
lua require('lua-lsp')
source $HOME/.config/nvim/conf-plugins.vim
source $HOME/.config/nvim/mappings-plugins.vim

source $HOME/.config/nvim/commands-tiagoprn-functions.vim
source $HOME/.config/nvim/mappings-tiagoprn-functions.vim

