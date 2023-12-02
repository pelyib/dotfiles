local pelyib = {}

pelyib.opts = {
    -- Order is important, it will load the modules in the given order.
    modules = {
        variables = true,
        vim = true,
        pluginmanager = true,
    },
    localModulePath = '~/.config/nvim/lua/local/',
}

function pelyib.ensurePluginManagerInstalled()
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

function pelyib.setupModules()
    for module, enabled in pairs(pelyib.opts.modules) do
        if enabled then
            pelyib.setupLocalBeforeModule(module)

            local fullModuleName = 'pelyib.' .. module
            require(fullModuleName).setup()

            pelyib.setupLocalAfterModule(module)
        end
    end
end

function pelyib.setupProjectModule()
    local cwd = vim.fn.getcwd()
    local projectModule = cwd .. '/.local.lua'
    if vim.fn.filereadable(vim.fn.expand(projectModule)) == 1 then
        vim.cmd.luafile(projectModule)
    end
end

function pelyib.setupLocalModule(moduleName)
    local localModuleName = 'local.' .. moduleName
    local localModuleFile = pelyib.opts.localModulePath .. moduleName .. '.lua'

    if vim.fn.filereadable(vim.fn.expand(localModuleFile)) == 1 then
        require(localModuleName).setup()
    end
end

function pelyib.setupLocalBeforeModule(moduleName)
    pelyib.setupLocalModule('before' .. moduleName)
end

function pelyib.setupLocalAfterModule(moduleName)
    pelyib.setupLocalModule('after' .. moduleName)
end

function pelyib.setup(opts)
    opts = opts or {}
    pelyib.opts = vim.tbl_deep_extend("force", pelyib.opts, opts)

    pelyib.ensurePluginManagerInstalled()
    pelyib.setupModules()
    pelyib.setupProjectModule()
end

return pelyib
