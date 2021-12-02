# Zsh

"[Zsh](https://www.zsh.org/) is a shell designed for interactive use, although it is also a powerful scripting language. More information can be found on the "Zsh Web Pages" sites."

## Installation

- make a copy of the [.zshenv.dist](dotfiles/.zshenv.dist), remove .dist from its name
- update the values there
- Run the `installer.sh` script
- optional: change your default shell (e.g.: `chsh -s /bin/zsh`)

## Usage

Just switch to Zsh
`$ zsh`

### Safe / test mode

You can play with it in Docker, check the [Makefile](Makefile) for more details
```
❯ make
Usage:
  make [target] [arg="val"...]

Targets:
  build                     Build the docker image
  run                       Spin up the built image
```
