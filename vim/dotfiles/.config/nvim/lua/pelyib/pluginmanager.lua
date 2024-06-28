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
        if pluginconfig and pelyibConf then
            vim.g.pelyib = vim.tbl_deep_extend("force", pelyibConf, {pluginconfig = pluginconfig})
        else
            print("banan")
            print(vim.inspect(pelyibConf))
        end
    else
        vim.notify("pluginconfig could not be loaded")
    end


    require("lazy").setup("plugins", {})
end

return M
