local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(_, bufnr)
    lsp.default_keymaps({buffer = bufnr})

    local builtin = require('telescope.builtin')

    vim.keymap.set('n', 'gr', function () builtin.lsp_references({include_current_line = true}) end, {buffer = true})
    vim.keymap.set('n', 'gd', function () builtin.lsp_definitions() end, {buffer = true})
    -- Don't know why but lsp-zero does not register this
    vim.keymap.set('n', 'gi', function () builtin.lsp_implementations() end, {buffer = true})
end)

lsp.setup()
