---@enum level
local level = {
    DEBUG = 100,
    INFO = 200,
    WARNING = 300,
    ERROR = 400,
}


---@class M
local M = {
    verbose = {
        level = level.INFO,
    },
}

local function notify(level, message)
    if level >= M.verbose.level then
        vim.notify(vim.inspect(message), level/100, {})
    end
end

function M.debug(message)
    notify(level.DEBUG, message)
end

function M.info(message)
    notify(level.INFO, message)
end

function M.warning(message)
    notify(level.WARNING, message)
end

function M.error(message)
    notify(level.ERROR, message)
end


return M
