# Migration

## From 0.0.8 to 0.0.11

### NoeVim

- Remove the links or files from the ~/.config/nvim/
- Remove the ~/.config/nvim folder
- Create the [local/init.lua](vim/dotfiles/.config/nvim/lua/local/init.lua) from the [init.lua.dist](vim/dotfiles/.config/nvim/lua/local/init.lua.dist)
- Link the [nvim](/vim/dotfiles/.config/nvim) folder to ~/.config/nvim

## From 0.0.7 to 0.0.8

### NeoVim

- Remove the link from ~/.config/nvim/ folder to .nvim.config and .local.nvim
- Create links to .nvim.vim and .local.vim again
