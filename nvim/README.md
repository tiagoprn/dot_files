# nvim

This is my modular neovim configuration.

Be careful: it is WIP, based on my vim configuration on this repo.

The package manager I use on neovim is "packer".

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

