local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local install_plugins = false

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  print('Installing packer...')
  local packer_url = 'https://github.com/wbthomason/packer.nvim'
  vim.fn.system({'git', 'clone', '--depth', '1', packer_url, install_path})
  print('Done.')

  vim.cmd('packadd packer.nvim')
  install_plugins = true
end

require('packer').startup(function(use)
  use {
    "anuvyklack/windows.nvim",
    requires = "anuvyklack/middleclass",
    config = function()
      require('windows').setup()
    end
  }

  use {
    'stevearc/aerial.nvim',
    config = function() require('aerial').setup() end
  }

  use 'neovim/nvim-lspconfig'
  use 'nvim-treesitter/nvim-treesitter'

  -- Install cmp
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  use 'scrooloose/nerdtree'
  use 'tpope/vim-surround'
  use 'morhetz/gruvbox'
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'tpope/vim-fugitive'
  use 'scrooloose/nerdcommenter'
  use 'jiangmiao/auto-pairs'
  use 'Xuyuanp/nerdtree-git-plugin'
  use 'tiagofumo/vim-nerdtree-syntax-highlight'
  use 'ryanoasis/vim-devicons'
  use 'airblade/vim-gitgutter'
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'
  use 'SirVer/ultisnips'
  use 'honza/vim-snippets'
  use 'elzr/vim-json'
  use 'airblade/vim-rooter'
  use 'aklt/plantuml-syntax'
  use 'vim-vdebug/vdebug'
  use 'phpactor/phpactor'
  use 'stephpy/vim-php-cs-fixer'

  use({
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
        require("lspsaga").setup({})
    end,
  })

  if install_plugins then
    require('packer').sync()
  end
end)
