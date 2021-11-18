# nvim

This is my modular neovim configuration.

The package manager I use on neovim is "packer".


## Setting up

- **IMPORTANT:** Before starting, make sure you already have neovim installed (as appimage or compiled). This assumes neovim 0.5+ (which at this time can only be obtained through cloning the master branch).

- To (re)set your environment, run the script `../configure_neovim.sh` on the previous directory. It will delete existing environment and clone the packer repo.

- Install programs to allow lsp support for bash shellscripts:
```
# shfmt: a formatter for shell scripts
$ GO111MODULE=on go get mvdan.cc/sh/v3/cmd/shfmt
$ sudo cp ~/go/bin/shfmt /usr/bin/

# linter
$ sudo apt install -y shellcheck

# Treesitter parsers
$ sudo apt install -y npm

# Language Server
$ sudo snap install bash-language-server
```

- Install efm-langserver (flexible language server to allow configuring custom linters and formatters for multiple languages using lsp):
```
$ go get github.com/mattn/efm-langserver
$ sudo cp ~/go/bin/efm-langserver /usr/bin
# IMPORTANT: The efm configuration can be found on this repository at 'efm-langserver/config.yaml'.
```
NOTES: efm runs as an additional Language Server attached for doing formatting, linting. No problem at all with built-in lsp. efm is really cool and you can configure in one place every format/lint tools you want depending on the language. It's a must have and as it's written in Go you can expect it to be light and fast.

- Then, run:
```
$ nvim

(run below on VISUAL MODE)

:PackerCompile
:PackerSync
```

## Run lua functions

```
(run below on VISUAL MODE)
:lua require'sample'.runExternalCommand()
:lua require'sample'.checkForErrorsAsBooleanVariable()
:lua require'sample'.welcomeToLua()
```

## Install lua language server

```
$ sudo apt install -y clang10-dev ninja-build
$ sudo ln -s /usb/bin/clang-10 /usb/bin/clang
$ sudo su
$ cd /opt
$ git clone https://github.com/sumneko/lua-language-server
$ cd lua-language-server
$ git submodule update --init --recursive
$ cd 3rd/luamake
$ compile/install.sh
$ cd ../..
$ ./3rd/luamake/luamake rebuild
$ cp bin/Linux/lua-language-server /usr/bin
$ sudo chown -R $(id -u).$(id -g) /opt/lua-language-server
```


## More language servers

- flutter/rust: <https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins>


## Developing lua plugins interactively

- E.g. using `scratchpad.lua`:
```
:Luapad

require("plenary.reload").reload_module'tiagoprn.scratchpad'
require'tiagoprn.scratchpad'.createQuickNote()

```

- To see the plugin output: `:messages`, to clear all messages: `:messages clear`

## Other

- `viminfo` on neovim: Instead of the viminfo format, neovim uses `shada` files. For more details: `:h shada`. In linux, the default path of this file is: `$HOME/.local/share/nvim/shada/main.shada`.

