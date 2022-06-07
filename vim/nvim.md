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

- link / copy [config file](/vim/.nvim.config) to `~/.config/nvim/init.vim`

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
