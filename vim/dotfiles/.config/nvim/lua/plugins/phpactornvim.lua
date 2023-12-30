return {
    "gbprod/phpactor.nvim",
    tag = "v1.0.1",
    config = function()
        require("phpactor").setup({
            install = {
                path = vim.fn.stdpath("data") .. "/lazy/phpactor",
                branch = "2023.09.24.0",
                bin = vim.fn.stdpath("data") .. "/lazy/phpactor/bin/phpactor",
                php_bin = "php",
                composer_bin = "composer2",
                git_bin = "git",
                check_on_startup = "none",
            },
            lspconfig = {
                enabled = false,
                options = {},
            },
        })
    end
}
