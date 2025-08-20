local M = {}

M.setup = function ()
    local lazy_ok, lazy = pcall(require, "lazy")
    if not lazy_ok then
        vim.notify("Failed to load lazy.nvim plugin manager", vim.log.levels.ERROR)
        return
    end
    lazy.setup("plugins", {})
end

return M
