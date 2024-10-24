# NeoVim

[link](https://neovim.io/)

## Installation

Following steps will describe how to install everything

### Nvim

- [install nvim](https://github.com/neovim/neovim/wiki/Installing-Neovim)

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

### ripgrep

[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) Neovim plugin requires it.
[instruction](https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation)

## Configuration

TODO: describe configuration


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
