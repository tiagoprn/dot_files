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


## Packer cheatsheet

```
-- You must run this or `PackerSync` whenever you make changes to your plugin configuration
:PackerCompile

-- Only install missing plugins
:PackerInstall

-- Update and install plugins
:PackerUpdate

-- Remove any disabled or unused plugins
:PackerClean

-- Performs `PackerClean` and then `PackerUpdate`
:PackerSync

-- Loads opt plugin immediately
:PackerLoad completion-nvim ale
```


## Run lua functions

```
(run below on VISUAL MODE)
:lua require'sample'.runExternalCommand()
:lua require'sample'.checkForErrorsAsBooleanVariable()
:lua require'sample'.welcomeToLua()
```

