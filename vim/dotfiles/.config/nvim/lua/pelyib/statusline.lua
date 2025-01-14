local M = {}

M.calc =function ()
    -- TODO if the buff is not a file or the file is not saved return a simplified statusline

    local root = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    local relative_path = vim.fn.expand("%:.")
    local current_line_length = #vim.fn.getline('.')
    local code_first_lev = ""
    local code_second_lev = ""
    local code_path = ""
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

    -- [project/root folder]{relative path}::{namespace.class}.{method}            {line num of curs} / {all lines num} | {col of curs}-{len of row} | percent of cursor position
    return string.format(
        "[%s]%s%s %%=%%l / %%L | %%v-%d | %%p %%",
        root,
        relative_path,
        code_path,
        current_line_length
    )
end

return M
