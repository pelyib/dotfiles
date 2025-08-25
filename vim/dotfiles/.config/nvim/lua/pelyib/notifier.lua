---@enum level
local level = {
	DEBUG = 100,
	INFO = 200,
	WARNING = 300,
	ERROR = 400,
}

---@class pelyib.notifier
---@field opts defaultOpts
local M = {}

---@class defaultOpts
local defaultOpts = {
	vimNotOpts = {
		title = "[pelyib.notifier] - default",
	},
}

---@param level integer
---@param message any
local function notify(level, message)
	vim.notify(vim.inspect(message), level / 100, M.opts.vimNotOpts)
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

---@param opts defaultOpts
function M.setup(opts)
	M.opts = vim.tbl_deep_extend("force", defaultOpts, opts or {})
end

return M
