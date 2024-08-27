local M = {}

M.vars = {
    pelyib = function ()
        vim.g.pelyib = {}
    end,
    gitblamnvim = function ()
        vim.g.gitblame_date_format = "%Y-%m-%dT%H:%M:%S (%r)"
        vim.g.gitblame_message_template = "[<author>@<date>] <summary>"
    end,
    lazy = function ()
    end,
    phpcsfixer = function ()
        vim.g.php_cs_fixer_allow_risky = 'yes'
    end,
    vim = function ()
        vim.g.loaded_ruby_provider = 0
        vim.g.loaded_perl_provider = 0
    end,
    neotree = function ()
        -- disable netrw at the very start of your init.lua (strongly advised)
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        -- set termguicolors to enable highlight groups
        vim.opt.termguicolors = true
    end
}

M.setup = function ()
    for _, fn in pairs(M.vars) do
        fn()
    end
end

return M
