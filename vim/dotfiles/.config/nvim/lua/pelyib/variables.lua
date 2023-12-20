local M = {}

M.vars = {
    gitblamnvim = function ()
        vim.g.gitblame_date_format = "%Y-%m-%dT%H:%M:%S (%r)"
        vim.g.gitblame_message_template = "[<author>@<date>] <summary>"
    end,
    lazy = function ()
        vim.g.pelyib_codeium_enabled = false
    end,
    phpcsfixer = function ()
        vim.g.php_cs_fixer_allow_risky = 'yes'
    end
}

M.setup = function ()
    for _, fn in pairs(M.vars) do
        fn()
    end
end

return M
