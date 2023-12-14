return {
    "gbprod/phpactor.nvim",
    --tag = "v1.0.0", latest fix is not released yet and causing an error [botond.pelyi]
    commit = "5c8227d324a19c4c54d38c262241ce5687f38414",
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
