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
            require("lazy").setup("plugins", {})
        else
            vim.notify("pluginconfig or pelyibConf could not be loaded")
            vim.notify("global config" .. vim.inspect(pelyibConf))
            vim.notify("local plugin config" .. vim.inspect(pluginconfig))
        end
    else
        vim.notify("pluginconfig could not be loaded")
        vim.notify("error: " .. vim.inspect(locConfig))
    end
end

return M
