local M = {}

M.opts = {
    -- Order is important, it will load the modules in the given order.
    modules = {
        variables = true,
        vim = true,
        pluginmanager = true,
        greater = true,
        lsp = true,
        telescope = true,
        gitblame = true,
        nvimufo = true,
        toggleterm = true
    },
    localModulePath = '~/.config/nvim/lua/local/',
}

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
    for module, enabled in pairs(M.opts.modules) do
        if enabled then
            M.setupLocalBeforeModule(module)

            local fullModuleName = 'pelyib.' .. module
            require(fullModuleName).setup()

            M.setupLocalAfterModule(module)
        end
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
    local localModuleFile = M.opts.localModulePath .. moduleName .. '.lua'

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

M.setup = function (opts)
    opts = opts or {}
    M.opts = vim.tbl_deep_extend("force", M.opts, opts)

    M.ensurePluginManagerInstalled()
    M.setupModules()
    M.setupProjectModule()
end

return M
