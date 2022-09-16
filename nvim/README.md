# nvim

This repo contains my modular neovim configuration.

The package manager I use on neovim is "packer".

## Install methods (from master branch on github repo - bleeding edge)

### 1) Manual compiling:

```bash
$ sudo su
$ mkdir -p /opt/src
$ cd /opt/src
$ git clone https://github.com/neovim/neovim.git
$ cd neovim
$ ldconfig
$ make clean && make CMAKE_BUILD_TYPE=Release && make install
```

### 2) Nightly appimage:

```bash
$ sudo su
$ mkdir -p /opt/nvim
$ cd /opt/nvim
$ wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
$ ln -s /opt/nvim/nvim.appimage /usr/bin/nvim
```

**IMPORTANT**: On debian's derivative distributions, after installing, you can do the optional step below to link the default and vi editor to nvim:

```bash
$ update-alternatives --install /usr/bin/editor editor /usr/local/bin/nvim 1 && \
update-alternatives --set editor /usr/local/bin/nvim && \
update-alternatives --install /usr/bin/vi vi /usr/local/bin/nvim 1 && \
update-alternatives --set vi /usr/local/bin/nvim
```

## Configuration

### 1) Install latest version of node

```bash
$ curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
$ sudo apt install -y nodejs
```

### 2) Install language servers (you must start here)

#### python

To be able to use virtualenvs in python projects but not have to install the library pynvim on each one of them, I can create a virtualenv called neovim (e.g. on python 3.10+), and install the nvim requirements there. Then, the configuration `g:python3_host_prog` on my `init.vim` will point to the python interpreter that has the integration library. Reference: <https://neovim.io/doc/user/provider.html#python-virtualenv>

E.g. on how to setup that virtualenv (adapted to my workflow):

```bash
$ pyenv virtualenv 3.10.4 neovim
$ pyenv activate neovim
$ pip install -r /storage/src/devops/python/requirements.nvim-lsp  # https://github.com/tiagoprn/devops/blob/master/python/requirements.nvim-lsp
```

That will install not only pynvim, but also other packages related to python LSP on neovim (pylsp - python language server, black, pylint, isort, etc...) on this common environment. If the need arises to use different versions of any of them, I can manually install the libraries at `/storage/src/devops/python/requirements.nvim-lsp` on the project's virtualenv.

#### bash

- Bash Language Server:
```bash
# Install
$ sudo npm i -g bash-language-server

# Update bash-language-server.
$ sudo npm update --location=global

# Test bash-language-server.
$ bash-language-server -v
```

- shellcheck: linter
```bash
$ sudo apt install -y shellcheck
```

- shfmt: formatter for shell scripts:
```bash
$ GO111MODULE=on go get mvdan.cc/sh/v3/cmd/shfmt
$ sudo cp ~/go/bin/shfmt /usr/bin/
```

NOTE: Treesitter parsers will be installed through npm. Commands to inspect that:
```bash
:TSInstallInfo  # List all available languages and their installation status
:TSUpdate       # Updates all parsers
:TSUpdate xyz   # Updates xyz language parser
```

#### lua

- lua-language-server (sumneko):
	- Download a release from this page: <https://github.com/sumneko/lua-language-server/releases>
	- Uncompress the release at `/opt/src/lua-language-server`
	- Create a symbolic link to the wrapper script:
	```bash
	$ sudo ln -s /storage/src/dot_files/nvim/etc/lua-language-server /usr/local/bin/lua-language-server
	```

- stylua: install using rust package manager:
```bash
$ cargo install stylua
```

### 3) Setting up neovim

- **IMPORTANT:** Before starting, make sure you already have neovim installed (as appimage or compiled). This assumes neovim 0.7+ (which at this time can only be obtained through cloning the master branch). Also make sure you have installed the language servers and related programs/packages.

- To (re)set your environment, run the script `../configure_neovim.sh` on the previous directory. It will delete existing environment and clone the packer repo.

- Run:
```
$ nvim

(run below on VISUAL MODE)

:PackerCompile
:PackerSync
```

- To see the plugins output: `:messages`, to clear all messages: `:messages clear`

## Macros:

- Record a macro:
```
(NORMAL) q<letter><commands>q
```

(I have the "marvim" plugin installed, which allows persisting macros for use in the future.)

- To execute the macro <number> times (once by default), type:
```
<number-of-times>@<letter>
```

- So, the complete process looks like:
```
qa      - start recording to register a
...	    - your complex series of commands
q	      - stop recording
@a	    - execute your macro
@@	    - execute your macro again
99@a    - execute your macro 99 times
```

## Script nvim commands:
```bash
$ nvim --cmd 'echo "This runs before .vimrc"' -c ':call UltiSnips#ListSnippets()' -c '<Esc>' -c ':q!'
$ nvim -c ':call UltiSnips#ListSnippets()' -c ':q!'
$ nvim +PluginInstall +qall
```


## Other

- `viminfo` on neovim: Instead of the viminfo format, neovim uses `shada` files. For more details: `:h shada`. In linux, the default path of this file is: `$HOME/.local/share/nvim/shada/main.shada`.

- Running lua functions:

``` vim
(run below on VISUAL MODE)
:lua require'sample'.runExternalCommand()
:lua require'sample'.checkForErrorsAsBooleanVariable()
:lua require'sample'.welcomeToLua()
```

- Developing lua plugins interactively (e.g. using `scratchpad.lua`):

``` lua
:Luapad

require("plenary.reload").reload_module'tiagoprn.scratchpad'
require("tiagoprn.scratchpad").createFleetingNote()
```

- Here is a succint page explaining the basics on lua programming: <https://riptutorial.com/lua>

- Where I can find the "extended library" that neovim exposes to lua? To discover the available methods, I can use the autocomplete provided by the lua LSP when writing code on INSERT mode. The following namespaces are available:
```lua
-- neovim lua API:
vim.<C-Space>
vim.api.<C-Space>
vim.fn.<C-Space>

-- my custom modules with other functions:
local helpers = require("tiagoprn.helpers")
local scratchpad = require("tiagoprn.scratchpad")
helpers.<C-Space>
scratchpad.<C-Space>
```

On those namespaces, there are string and list manipulation functions (that I wasted effort reinventing at `tiagoprn.helpers` not knowing that they existed - I must fix that when possible)

- If I receive error "E41: Out of memory!" when opening a file, edit it outside of nvim and save it.

- How export the mappings to an external file:
1. Inside nvim:
```bash
:redir >> ~/mymaps.txt
:map
:redir END
```
2. Starting nvim with the commands above, using "+" to script the commands:
```bash
nvim +"redir >> /tmp/automap.txt" +"map" +"redir END" +"qa!"
```
(you can use `:verbose map` instead of `:map` to get more info on the mappings.)

- If I need to create/run more commands or a command palette using telescope pickers to choose from a list, I can create them on `lua/easypick-conf.lua` (I have examples there and one picker I created to run make commands using harpoon.)
