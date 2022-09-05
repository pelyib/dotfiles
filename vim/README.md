# NeoVim

[link](https://neovim.io/)

## Installation

Following steps will describe how to install everything

### Nvim

- [install nvim](https://github.com/neovim/neovim/wiki/Installing-Neovim)
- [install vim-plug](https://github.com/junegunn/vim-plug#unix-linux), a plugin manager

### NodeJS

- install plugin: `npm install -g neovim`

### Python plugins

From more info: `:help provider-python`

- install pip 
  - python3: `python3 -m ensurepip --default-pip`
  - python2: `python -m ensurepip --default-pip --user`
- install plugin
  - python3: `python3 -m pip install --user --upgrade pynvim`
  - python2: `python2 -m pip install --user --upgrade pynvim`

## Configuration

- link / copy [config file](/vim/dotfiles/.nvim.vim) to `~/.config/nvim/init.vim`
- create a local env config based on the [.local.vim.dist](/vim/dotfiles/.local.vim.dist), link copy to `~/.config/nvim/local.vim`
- link / copy [Phpactor files](/vim/vendor/phpactor/) to `~/.config/phpactor/`

## Install plugins

- start NeoVim: `$ nvim`
- ESC then type: `:PlugInstall`

## Testing

Use the Makefile to build and run it in Docker container:

```bash
❯ make
Usage:
  make [target] [arg="val"...]

Targets:
  build    Build the docker image
  run      Spin up the built image
```

## Usage

Just simple run `nvim` in your preferred terminal app or use the [nvim](nvim) script
