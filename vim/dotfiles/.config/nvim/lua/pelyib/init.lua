local M = {}

-- Order is important, it will load the modules in the given order.
M.modules = {
    'variables',
    'vim',
    'pluginmanager',
    'greater',
    'lsp',
    'telescope',
    'gitblame',
    'nvimufo',
    'toggleterm'
}

M.localModulePath = '~/.config/nvim/lua/local/'

M.ensurePluginManagerInstalled = function ()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)
end

M.setupModules = function ()
    for key, module in pairs(M.modules) do
        M.setupLocalBeforeModule(module)

        local fullModuleName = 'pelyib.' .. module
        require(fullModuleName).setup()

        M.setupLocalAfterModule(module)
    end
end

M.setupProjectModule = function ()
    local cwd = vim.fn.getcwd()
    local projectModule = cwd .. '/.local.lua'
    if vim.fn.filereadable(vim.fn.expand(projectModule)) == 1 then
        vim.cmd.luafile(projectModule)
    end
end

M.setupLocalModule = function (moduleName)
    local localModuleName = 'local.' .. moduleName
    local localModuleFile = M.localModulePath .. moduleName .. '.lua'

    if vim.fn.filereadable(vim.fn.expand(localModuleFile)) == 1 then
        require(localModuleName).setup()
    end
end

M.setupLocalBeforeModule = function (moduleName)
    M.setupLocalModule('before' .. moduleName)
end

M.setupLocalAfterModule = function (moduleName)
    M.setupLocalModule('after' .. moduleName)
end

M.setup = function ()
    M.ensurePluginManagerInstalled()
    M.setupModules()
    M.setupProjectModule()
end

return M
