return {
    'kevinhwang91/nvim-ufo',
    tag = "v1.3.0",
    lazy = false,
    dependencies = {
        'kevinhwang91/promise-async'
    },
    config = function ()
        vim.o.foldcolumn = '1'
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true
        }
        local language_servers = require("lspconfig").util.available_servers()
        for _, ls in ipairs(language_servers) do
            require('lspconfig')[ls].setup({
                capabilities = capabilities
            })
        end

        require('ufo').setup()
    end
}
