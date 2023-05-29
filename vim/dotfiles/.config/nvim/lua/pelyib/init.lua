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
    'nvimufo'
}

M.localModulePath = '~/config/nvim/lua/local'

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

M.setupLocalBeforeModule = function (moduleName)
    local beforeModule = 'before' .. moduleName
    local beforeModuleName = 'local.' .. beforeModule
    local beforeModuleFile = M.localModulePath .. beforeModule .. '.lua'

    if vim.fn.filereadable(vim.fn.expand(beforeModuleFile, 'r')) == 1 then
        require(beforeModuleName).setup()
    end
end

M.setupLocalAfterModule = function (moduleName)
    local afterModule = 'after' .. moduleName
    local afterModuleName = 'local.' .. afterModule
    local afterModuleFile = M.localModulePath .. afterModule .. '.lua'

    if vim.fn.filereadable(vim.fn.expand(afterModuleFile, 'r')) == 1 then
        require(afterModuleName).setup()
    end
end

M.setup = function ()
    vim.cmd("echo 'init pelyib'")
    M.ensurePluginManagerInstalled()
    M.setupModules()
end

return M
