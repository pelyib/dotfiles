local M = {}

M.vars = {
    gitblamnvim = function ()
        --vim.g.gitblame_enabled = 0
        vim.g.gitblame_date_format = "%Y-%m-%dT%H:%M:%S (%r)"
        vim.g.gitblame_message_template = "[<author>@<date>] <summary>"
    end
}

M.setup = function ()
    for key, fn in pairs(M.vars) do
        fn()
    end
end

return M
