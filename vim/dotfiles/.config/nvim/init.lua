vim.opt.number=true
vim.opt.relativenumber=true
vim.opt.wrap=true
vim.opt.textwidth=120
vim.opt.tabstop=4
vim.opt.shiftwidth=4
vim.opt.softtabstop=4
vim.opt.expandtab=true
vim.opt.list=true
vim.opt.listchars={
  eol='$',
  tab='>-',
  trail='~',
  extends='>',
  precedes='<'
}
vim.opt.spell=true
vim.opt.shada=NONE

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    "folke/tokyonight.nvim",
  },
  {
    "sainnhe/everforest",
    config = function()
      vim.g.everforest_transparent_background = 2
    end
  },
  {
    "morhetz/gruvbox",
    config = function()
      vim.opt.termguicolors = true
    end
  },
  'nvim-tree/nvim-web-devicons',
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = { 
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function ()
      -- disable netrw at the very start of your init.lua (strongly advised)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- set termguicolors to enable highlight groups
      vim.opt.termguicolors = true
      require("neo-tree").setup({
        window = {
          position = "float"
        },
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            never_show = {
              ".DS_Store",
              "thumbs.db",
              ".git"
            }
          }
        }
      })
      vim.keymap.set('n', 'fb', ':NeoTreeFloatToggle<CR>')
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    config = function ()
      vim.cmd([[syntax off]])
      require("nvim-treesitter.configs").setup({
        ensure_installed = {"bash", "cmake", "css", "dockerfile", "dot", "graphql", "html", "lua", "make", "python", "javascript", "sql", "vim", "yaml", "regex", "go", "php", "markdown", "json"},
        highlight={
          enable=true,
          additional_vim_regex_highlighting=true,
        }
      })
    end
  },
  {
    'stevearc/aerial.nvim',
    config = function ()
      require('aerial').setup({
        close_automatic_events = {'unfocus'},
        layout={
          default_direction = 'float'
        },
        float={
          relative='win'
        }
      })
      vim.keymap.set('n', 'ar', ':AerialToggle<CR>')
    end
  },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {                                      -- Optional
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      {'williamboman/mason-lspconfig.nvim'}, -- Optional

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},     -- Required
      {'hrsh7th/cmp-nvim-lsp'}, -- Required
      {'L3MON4D3/LuaSnip'},     -- Required
    }
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    'akinsho/toggleterm.nvim',
    version = "v2.5.0",
    config = function ()
      require('toggleterm').setup({
        direction = 'float',
        open_mapping = [[<F7>]]
      })
      local Terminal = require('toggleterm.terminal').Terminal
      local _git = Terminal:new({ cmd = "gitui", hidden = true })
      function gitui_toggle()
        _git:toggle()
      end

      vim.keymap.set('n', '<leader>t', '<cmd>ToggleTerm<cr>')
      vim.keymap.set('n', '<leader>git', '<cmd>lua gitui_toggle()<cr>', {noremap = true, silent = true})
    end
  },
  {
    'goolord/alpha-nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      require'alpha'.setup(require'alpha.themes.startify'.config)
    end
  },
  {
    'Exafunction/codeium.vim',
    enable = false
  },
  {
    -- TODO: add build script to run composer install in the installed plugin directory [botond.pelyi]
    'phpactor/phpactor',
    config = function ()
      function PhpactorCreateNewObj()
        vim.api.nvim_call_function(
          'phpactor#rpc',
          { 'class_new', { current_path = vim.api.nvim_call_function('phpactor#_path', {}), variant = "default" } }
        )
      end

      function PhpactorImplementContract()
        vim.api.nvim_call_function(
          'phpactor#rpc',
          {
            'transform',
            {
              transform = 'implement_contracts',
              source = vim.api.nvim_call_function('phpactor#_source', {}),
              path = vim.api.nvim_call_function('phpactor#_path', {})
            }
          }
        )
      end

      vim.keymap.set('n', '<leader>pn', '<cmd>lua PhpactorCreateNewObj()<cr>')
      vim.keymap.set('n', '<leader>pi', '<cmd>lua PhpactorImplementContract()<cr>')
    end
  },
  {
    'stephpy/vim-php-cs-fixer',
    config = function ()
      function PhpCsFixerFixAll()
        vim.api.nvim_call_function('PhpCsFixerFixFile', {})
      end
      vim.keymap.set('n', 'csf', '<cmd>lua PhpCsFixerFixAll()<cr>')
      vim.g.php_cs_fixer_allow_risky = 'yes'
    end
  },
  {
    "jiangmiao/auto-pairs"
  }
}
require("lazy").setup(plugins, {})
vim.cmd([[colorscheme everforest]])

local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})

  vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', {buffer = true})
  vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', {buffer = true})
  -- Don't know why but lsp-zero does not register this
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
end)

lsp.setup()

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>gh', builtin.git_commits, {})
vim.keymap.set('n', '<leader>gfh', builtin.git_bcommits, {})

vim.keymap.set('n', 'gic', builtin.lsp_incoming_calls, {})
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})

function show_greatings()
  require("alpha").start(false, require("alpha").default_config)
end
vim.keymap.set('n', '<c-h>', '<cmd>lua show_greatings()<cr>')
--show_greatings()

require("local")
require("ui.help")
