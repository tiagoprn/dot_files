# nvim

This is my modular neovim configuration.

Be careful: it is WIP, based on my vim configuration on this repo.

The package manager I use on neovim is "packer".


## Setting up

- **IMPORTANT:** Before starting, make sure you have already compile neovim. This assumes neovim 0.5+ (which at this time can only be obtained through cloning the master branch).

- To (re)set your environment, run the script `../configure_neovim.sh` on the previous directory. It will delete existing environment and clone the packer repo.

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

