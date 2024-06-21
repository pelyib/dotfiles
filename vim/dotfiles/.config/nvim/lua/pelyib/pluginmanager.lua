local M = {}

local config = {
    config = {
        aerial = {},
        alpha = {},
        autopairs = {},
        codeium = {},
        comment = {},
        copilot = {},
        dapui = {},
        dap = {},
        devicons = {},
        dressing = {},
        everforest = {},
        gitblame = {},
        gruvbox = {},
        lspzero = {},
        neoclip = {},
        neodev = {},
        neotree = {},
        notify = {},
        phpactor = {},
        phpactornvim = {},
        phpcsfixer = {},
        telescope = {},
        toggleterm = {},
        treesitter = {},
        ufo = {},
    }
}

M.setup = function ()
    local loaded, locConfig = pcall(require, "local/pluginconfig")

    if loaded then
        local pluginconfig = vim.tbl_deep_extend("force", config, locConfig)
        local pelyibConf = vim.g.pelyib
        vim.g.pelyib = vim.tbl_deep_extend("force", pelyibConf, {pluginconfig = pluginconfig})
    end

    require("lazy").setup("plugins", {})
end

return M
