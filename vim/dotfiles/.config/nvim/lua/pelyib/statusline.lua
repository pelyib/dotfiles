local M = {}

M.calc =function ()
    local root = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

    if vim.bo.buftype == "nofile" or vim.bo.buftype == "quickfix" then
        return string.format(
            "%s | [  %s]",
            M.branch(),
            root
        )
    end

    local relative_path = vim.fn.expand("%:.")
    local current_line_length = #vim.fn.getline('.')
    -- [project/root folder]{relative path}::{namespace.class}.{method}            {line num of curs} / {all lines num} | {col of curs}-{len of row} | percent of cursor position
    return string.format(
        "%s | [  %s]%s%s %%=%%l / %%L | %%v-%d | %%p %%",
        M.branch(),
        root,
        relative_path,
        M.code(),
        current_line_length
    )
end

M.branch = function ()
    if vim.b.statusline_branch ~= nil then
        return vim.b.statusline_branch
    end

    local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
    if branch ~= "" then
        vim.b.statusline_branch = string.format(
            "  %s",
            branch
        )
        return vim.b.statusline_branch
    else
        return ""
    end
end

M.code = function ()
    local code_first_lev = ""
    local code_second_lev = ""
    local code_path = ""
    -- TODO: it does not work without the barbecue plugin
    local code = require("nvim-navic").get_data()
    if code ~= nil then

        -- TODO: iterate over the items
        -- select items based on the used language
        -- like PHP: use Namespace, Class, Method

        if code[1] ~= nil then
            local current_code = code[1] or {}
            code_first_lev = string.format(
                "%s%s",
                current_code.icon or "",
                current_code.name or ""
            )
        end

        if code[2] ~= nil then
            local current_code = code[2] or {}
            code_second_lev = string.format(
                "%s%s",
                current_code.icon or "",
                current_code.name or ""
            )
        end

        if code_first_lev ~= "" and code_second_lev ~= "" then
            code_path = string.format(
                "::%s.%s",
                code_first_lev,
                code_second_lev
            )
        elseif code_first_lev ~= "" then
            code_path = string.format(
                "::%s",
                code_first_lev
            )
        end
    end

    return code_path
end

return M
