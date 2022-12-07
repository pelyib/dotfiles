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

  use { "anuvyklack/windows.nvim",
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

  if install_plugins then
    require('packer').sync()
  end
end)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

require('lspconfig')['phpactor'].setup{
    on_attach = on_attach,
}
require('lspconfig')['gopls'].setup{
  cmd = {"gopls", "serve"},
  on_attach = on_attach,
}
require("lspconfig").vimls.setup{
  on_attach = require("aerial").on_attach,
}
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"bash", "cmake", "css", "dockerfile", "dot", "graphql", "html", "lua", "make", "python", "javascript", "sql", "vim", "yaml", "regex", "go", "php", "markdown", "json"},
  highlight={
    enable=true,
    additional_vim_regex_highlighting=true,
  }
}
