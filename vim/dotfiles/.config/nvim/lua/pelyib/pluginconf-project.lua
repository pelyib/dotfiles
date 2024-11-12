local M = {
    config = {}
}

M.setup = function ()
    local cwd = vim.fn.getcwd()
    local projectModule = cwd .. '/.local.lua'
    if vim.fn.filereadable(vim.fn.expand(projectModule)) == 1 then
        vim.cmd.luafile(projectModule)
        M.config = projectConf.config
        print(vim.inspect(M.config))
    end
end

return M
