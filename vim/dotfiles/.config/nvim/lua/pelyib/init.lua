local M = {}

-- Order is important, it will load the modules in the given order.
M.modules = {
    'variables',
    'vim',
    'pluginmanager',
    'greater',
    'lsp',
    'telescope'
}

M.installPluginManager = function ()
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

M.installModules = function ()
    for key, module in pairs(M.modules) do
        local fullModuleName = 'pelyib.' .. module
        local localModulePath = '~/.config/nvim/lua/local/'
        local beforeModule = 'before' .. module
        local beforeModuleName = 'local.' .. beforeModule
        local afterModule = 'after' .. module
        local afterModuleName = 'local.' .. afterModule
        local beforeModuleFile = localModulePath .. beforeModule .. '.lua'
        local afterModuleFile = localModulePath .. afterModule .. '.lua'

        if vim.fn.filereadable(vim.fn.expand(beforeModuleFile, 'r')) == 1 then
            require(beforeModuleName).setup()
        end

        require(fullModuleName).setup()

        if vim.fn.filereadable(vim.fn.expand(afterModuleFile, 'r')) == 1 then
            require(afterModuleName).setup()
        end
    end
end

M.setup = function ()
    vim.cmd("echo 'init pelyib'")
    M.installPluginManager()
    M.installModules()
end

return M
