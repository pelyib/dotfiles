# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.39] - 2025-01-22

### Added
- [NVIM] - custom statusline implementation

## [0.0.38] - 2024-12-30

### Added
- [NVIM] - [Quick navigation within a file #14](https://github.com/pelyib/dotfiles/issues/14)
- [NVIM] - Golang support in neotest

### Removed
- [NVIM] - aerial.nvim, replaced with navbuddy

## [0.0.37] - 2024-12-04

### Added
- [NVIM] - install [neotest](https://github.com/nvim-neotest/neotest)
- [NVIM] - [neotest-phpunit](https://github.com/olimorris/neotest-phpunit), [V13Axel/neotest-pest](https://github.com/V13Axel/neotest-pest), [nvim-neotest/neotest-jest](https://github.com/nvim-neotest/neotest-jest) added to neotest
- [NVIM] - [phpic](./vim/vendor/neotest/phpic) script to run PHPUnit and Pest in a container

### Changed
- [NVIM] - Refactored host and project based configuration loading, check the [Migration](MIGRATION.md) guide

## [0.0.36] - 2024-08-27

### Added
- [NVIM] - install [noice.nvim](https://github.com/folke/noice.nvim)

### Changed
- [NVIM] - Neotree vim global variables moved to proper place

## [0.0.35] - 2024-08-10

### Changed
- [NVIM] - fine tune CMP sources
- [ZSH] - small adjustment

## [0.0.34] - 2024-08-09

### Fixed
- [NVIM] - pelyib module loading issue, order is fixed

## [0.0.33] - 2024-07-08

### Added
- [NVIM] - install bracket-pairs.nvim

## [0.0.32] - 2024-07-03

### Changed
- [NVIM] - replace neodev with lazydev

### Removed
- [NVIM] - everforest color scheme, not used anymore

## [0.0.31] - 2024-07-02

### Added
- [NVIM] - phpactor installer script

## [0.0.30] - 2024-06-27

### Added
- [NVIM] - install rebelot/kanagawa.nvim color scheme
- [NVIM] - Mason install default LSP servers

### Changed
- [NVIM] - treesitter version bump

## [0.0.29] - 2024-06-20

### Added
- [NVIM] - module existence checking in after scripts
- [NVIM] - module config merged with local

### Changed
- [NVIM] - most of the modules are disabled

## [0.0.28] - 2024-06-18

### Changed
- [NVIM] - NeoVim 0.10.0 support, some plugin caused crashes
- [NVIM] - all plugins got the lazy `enabled` option

### Removed
- [NVIM] - treesitter-playground [Github issue #6](https://github.com/nvim-treesitter/playground/issues/126)

## [0.0.27] - 2024-06-13

### Added
- [NVIM] - run ESLint fix on save
- [NVIM] - install Copilot plugin

## [0.0.26] - 2024-06-11

### Changed
- [NVIM] - open Aerial plugin in Telescope

## [0.0.25] - 2024-05-20

### Changed
- [ZSH] - refactor installer script to work outside of containerized env

## [0.0.24] - 2024-04-18

### Added
- [NVIM] - spell check: working with PHP files (including camel case)

## [0.0.23] - 2024-01-09

### Changed
- [NVIM] - shell script executor: callback fn is injectable
- [NVIM] - notifier: opts is injectable

## [0.0.22] - 2024-01-08

### Changed
- [NVIM] - PHP test runner now list the available suites

## [0.0.21] - 2024-01-07

### Changed
- [NVIM] - PHP test runner refactored, command building can be injected.
- [NVIM] - Lazy: specify dependency version

### Removed
- [NVIM] - remove local/init.lua.dist because other files took over its job

## [0.0.20] - 2023-12-30

### Added
- [NVIM] - run PHP test from neovim

### Changed
- [NVIM] - Lazy: specify dependency version 

## [0.0.19] - 2023-12-24

### Added
- [NVIM] - install [rcarriga/nvim-notify](https://github.com/rcarriga/nvim-notify)

## [0.0.18] - 2023-12-20

### Added
- [NVIM] - keymap for telescope-live-grep-args

### Changed
- [NVIM] - telescope.lsp_reference doesn't show the line in the result list
- [NVIM] - add some keymaps to the greater definition
- [NVIM] - move PHP related things to after/ftplugin

## [0.0.17] - 2023-12-19

### Added
- [NVIM] - telescope.live_grep: search for text under the cursor in normal or in selected text in visual mode

### Changed
- [NVIM] - telescope.lsp_reference: exclude definition

## [0.0.16] - 2023-12-18

### Added
- [NVIM] - install [nvim-telescope/telescope-live-grep-args.nvim](https://github.com/nvim-telescope/telescope-live-grep-args.nvim)

## [0.0.15] - 2023-12-14

### Fixed
- [NVIM] - use commit instead of a tag for phpactor.nvim because last fixes are not released yet

## [0.0.14] - 2023-12-02

### Changed
- [NVIM] - refactor whole configuration, apply standard `plugins` and `after` folder structure

## [0.0.13] - 2023-11-26

### Added
- [ZSH] - aliases file

### Fixed
- Changelog date format

## [0.0.12] - 2023-05-29

### Added
- [NVIM] - before and after local modules around the `pelyib` modules
- [NVIM] - load project based lua file

### Changed
- [NVIM] - introduce `pelyib` lua module, move and split the init.lua to specific modules
- [NVIM] - maintain the PHP-CS-FIXER rules

### Removed
- [NVIM] - init.lua.dist, use before and after local modules instead 

## [0.0.11] - 2023-05-23

### Changed
- [NVIM] - configuration is in lua instead of vimscript, more details in the [README.md](/vim/README.md)

## [0.0.10] - 2022-12-28

### Changed
- [NVIM] - maintain the [Dockerfile](vim/Dockerfile)

## [0.0.9] - 2022-09-05

### Added
- [GIT] - [pre-commit-jira](git/hooks/pre-commit-jira) script to prevent the usage of a closed / cancelled ticket number in the commit message

### Removed
- [Neovim] - coc-sh because it causes issues

## [0.0.8] - 2022-09-02

### Added
- [MIGRATION.md](MIGRATION.md) file for fast migration between versions

### Changed
- Rename "application.md" files to README.md
- Reformat and add short description about the apps in the root [README.md](/README.md)
- [GIT] - [prepare-commit-msg](git/hooks/prepare-commit-msg) is executable now

### Fixed
- [NeoVim] - dotfiles extension, all them is .vim

## [0.0.7] - 2022-08-18

### Added
- [NeoVim] - [PHP Coding Standards Fixer](https://github.com/FriendsOfPHP/PHP-CS-Fixer) with a [configuration](/vim/vendor/php-cs/.php-cs)
- [NeoVim] - Optional [local config](/vim/dotfiles/.local.nvim.dist), and project config
- [NeoVim] - [Phpactor configuration](/vim/vendor/phpactor/)
- [NeoVim] - a function to refresh after VCS change

### Removed
- [NeoVim] - Remove Vitor's config

## [0.0.6] - 2022-08-03

### Added
- [phpactor](https://github.com/phpactor/phpactor)

## [0.0.5] - 2022-06-13

### Added
- Do not indent style and script tag's body in HTML

## [0.0.4] - 2022-06-08

### Added
- Javascript and HTML LSP support

## [0.0.3] - 2022-06-07

### Added
- Enable spell check in VIM

### Fixed
- Typos

## [0.0.2] - 2022-04-06

### Added
- GIT hooks ([prepare-commit-msg](git/hooks/prepare-commit-msg))
- [SirVer/ultisnips](https://github.com/SirVer/ultisnips) and enable it

### Fixed
- Typo in [.gitignore_global](git/.gitignore_global)

## [0.0.1] - 2021-12-02

### Added
- GIT dotfiles
- ZSH dotfiles
- VIM / NeoVim dotfiles
