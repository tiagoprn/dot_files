# nvim

This is my modular neovim configuration.

The package manager I use on neovim is "packer".

## Setup

### 1) Install language servers (you must start here)

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
$ sudo snap install bash-language-server
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

- Treesitter parsers (they are installed through npm):
```bash
$ sudo apt install -y npm
```

#### lua

- lua-language-server (sumneko): Download a release from this page: <https://github.com/sumneko/lua-language-server/releases>

- stylua: install using rust package manager:
```bash
$ cargo install stylua
```

### 2) Setting up neovim

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
require'tiagoprn.scratchpad'.createQuickNote()
```

