local M = {}

M.setup = function ()
    vim.opt.number=true
    vim.opt.relativenumber=true
    vim.opt.wrap=true
    vim.opt.textwidth=120
    vim.opt.tabstop=4
    vim.opt.shiftwidth=4
    vim.opt.softtabstop=4
    vim.opt.expandtab=true
    vim.opt.list=true
    vim.opt.listchars={
        eol='$',
        tab='>-',
        trail='~',
        extends='>',
        precedes='<'
    }
    vim.opt.spell=true
    vim.opt.shada=NONE
    vim.opt.scrolloff=5000
    vim.opt.scroll=10

    -- Temporary solution: https://github.com/f-person/git-blame.nvim/issues/65
    vim.g.gitblame_enabled = 0
end

return M
