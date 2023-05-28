local M = {}

M.setup = function ()
    local lsp = require('lsp-zero').preset({})

    lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({buffer = bufnr})

        vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', {buffer = true})
        vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', {buffer = true})
        -- Don't know why but lsp-zero does not register this
        vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<cr>', {buffer = true})
    end)

    lsp.setup()
end

return M

