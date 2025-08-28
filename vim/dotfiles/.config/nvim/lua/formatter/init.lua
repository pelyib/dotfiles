--[[
Neovim Formatter Plugin

A flexible formatter plugin that supports both external command-line tools and built-in Vim formatters.

Usage Example:
```lua
require("formatter").setup({
    format_on_save = true,
    format_on_save_filetypes = { "lua", "javascript" },
    keybinding = "<leader>f",
    
    formatters = {
        prettier = {
            command = { "prettier", "--write", "%" },
            filetypes = { "javascript", "typescript", "json" },
            success_message = "Prettier: Formatting complete"
        },
        custom_lua_fmt = {
            command = { "env", "STYLUA_CONFIG=.stylua.toml", "stylua", "%" },
            filetypes = { "lua" },
            post_action = "reload"
        }
    }
})
```

Commands:
- `:Format` - Format current buffer based on filetype
- `:FormatWith <formatter>` - Format with specific formatter

Placeholders:
- `%` or `{filepath}` - Full file path
- `{filename}` - Filename with extension
- `{basename}` - Filename without extension  
- `{dirname}` - Directory path
--]]

-- Import type definitions
require("formatter.types")

local M = {}

-- Configuration will be stored here
---@type FormatterPluginConfig
M.config = {}

-- Utility function to expand placeholders in command arguments
---@param command_list string[] List of command arguments
---@param context FileContext File context for placeholder replacement
---@return string[] expanded Expanded command arguments
local function expand_placeholders(command_list, context)
	local expanded = {}

	for _, arg in ipairs(command_list) do
		local expanded_arg = arg

		-- Replace common placeholders
		expanded_arg = string.gsub(expanded_arg, "%%", context.filepath or "")
		expanded_arg = string.gsub(expanded_arg, "{filepath}", context.filepath or "")
		expanded_arg = string.gsub(expanded_arg, "{filename}", context.filename or "")
		expanded_arg = string.gsub(expanded_arg, "{basename}", context.basename or "")
		expanded_arg = string.gsub(expanded_arg, "{dirname}", context.dirname or "")

		table.insert(expanded, expanded_arg)
	end

	return expanded
end

-- Get file context for placeholder replacement
---@return FileContext context File context information
local function get_file_context()
	local filepath = vim.fn.expand("%:p") -- Full path
	local filename = vim.fn.expand("%:t") -- Just filename with extension
	local basename = vim.fn.expand("%:t:r") -- Filename without extension
	local dirname = vim.fn.expand("%:p:h") -- Directory path

	return {
		filepath = filepath,
		filename = filename,
		basename = basename,
		dirname = dirname,
	}
end

-- Generic formatter function that works for all formatters
---@param formatter_name string Name of the formatter
---@param formatter_config FormatterConfig Formatter configuration
local function run_formatter(formatter_name, formatter_config)
	local command = formatter_config.command
	if not command then
		error("No command specified for formatter: " .. formatter_name)
		return
	end

	local context = get_file_context()
	local output = ""
	local exit_code = 0

	-- Handle function-based commands (for built-in Vim formatters)
	if type(command) == "function" then
		local success, result = pcall(command, context)
		if not success then
			error(string.format("Formatter '%s' function failed: %s", formatter_name, result))
			return
		end
		-- If function returns nil, it means it handled formatting internally
		if result == nil then
			output = "Formatted using built-in Vim functionality"
		else
			output = result
		end
	else
		-- Handle external command formatters

		-- Convert string command to list for consistency
		if type(command) == "string" then
			command = { command }
		end

		-- Expand placeholders in command
		local expanded_command = expand_placeholders(command, context)

		-- Build command with proper shell escaping
		local escaped_parts = {}
		for _, part in ipairs(expanded_command) do
			table.insert(escaped_parts, vim.fn.shellescape(part))
		end

		local full_command = table.concat(escaped_parts, " ")

		-- Execute the command
		output = vim.fn.system(full_command)
		exit_code = vim.v.shell_error

		if exit_code ~= 0 then
			error(string.format("Formatter '%s' failed (exit code %d): %s", formatter_name, exit_code, output))
			return
		end
	end

	-- Handle post-format actions
	local post_action = formatter_config.post_action or "reload"
	if post_action == "reload" then
		-- Reload the buffer to show changes
		vim.cmd("e!")
	elseif post_action == "none" then
		-- Do nothing
	elseif type(post_action) == "function" then
		-- Custom post action
		post_action(output, context)
	end

	-- Show success notification
	local message = formatter_config.success_message or (formatter_name .. ": Formatting complete")
	vim.notify(message, vim.log.levels.INFO)
end

-- Find formatter for the current filetype
---@param filetype string The filetype to find a formatter for
---@return string? formatter_name Name of the found formatter
---@return FormatterConfig? formatter_config Configuration of the found formatter
local function find_formatter_for_filetype(filetype)
	if not M.config.formatters then
		return nil, nil
	end

	for formatter_name, formatter_config in pairs(M.config.formatters) do
		if formatter_config.filetypes then
			for _, ft in ipairs(formatter_config.filetypes) do
				if ft == filetype then
					return formatter_name, formatter_config
				end
			end
		end
	end

	return nil, nil
end

-- Execute formatter for the current buffer based on its filetype
function M.format_buffer()
	local filetype = vim.bo.filetype
	local formatter_name, formatter_config = find_formatter_for_filetype(filetype)

	if not formatter_name then
		vim.notify("No formatter configured for filetype: " .. filetype, vim.log.levels.WARN)
		return
	end

	-- Execute the formatter
	local success, err = pcall(run_formatter, formatter_name, formatter_config)
	if not success then
		vim.notify("Formatting failed: " .. tostring(err), vim.log.levels.ERROR)
	end
end

-- Setup format on save functionality
local function setup_format_on_save()
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = vim.api.nvim_create_augroup("FormatterFormatOnSave", { clear = true }),
		callback = function()
			local filetype = vim.bo.filetype
			local formatter_name, formatter_config = find_formatter_for_filetype(filetype)

			-- Only format if formatter exists and has format_on_save enabled
			if formatter_name and formatter_config and formatter_config.format_on_save then
				local success, err = pcall(run_formatter, formatter_name, formatter_config)
				if not success then
					vim.notify("Auto-formatting failed: " .. tostring(err), vim.log.levels.ERROR)
				end
			end
		end,
	})
end

-- Setup commands
local function setup_commands()
	-- Create command to format current buffer
	vim.api.nvim_create_user_command("Format", function()
		M.format_buffer()
	end, { desc = "Format the current buffer" })

	-- Create command to format with specific formatter
	vim.api.nvim_create_user_command("FormatWith", function(opts)
		local formatter_name = opts.args
		if not formatter_name or formatter_name == "" then
			vim.notify("Usage: :FormatWith <formatter_name>", vim.log.levels.ERROR)
			return
		end

		local formatter_config = M.config.formatters and M.config.formatters[formatter_name]
		if not formatter_config then
			vim.notify("Formatter not found: " .. formatter_name, vim.log.levels.ERROR)
			return
		end

		local success, err = pcall(run_formatter, formatter_name, formatter_config)
		if not success then
			vim.notify("Formatting failed: " .. tostring(err), vim.log.levels.ERROR)
		end
	end, {
		nargs = 1,
		complete = function()
			local formatters = {}
			if M.config.formatters then
				for name, config in pairs(M.config.formatters) do
					if type(config) == "table" and config.command then
						table.insert(formatters, name)
					end
				end
			end
			return formatters
		end,
		desc = "Format with a specific formatter",
	})
end

-- Setup keybinding
local function setup_keybinding()
	local keybinding = M.config.keybinding
	if keybinding then
		vim.keymap.set("n", keybinding, M.format_buffer, { desc = "Format current buffer" })
	end
end

-- Built-in Vim formatters (always available)
---@return table<string, FormatterConfig> formatters Built-in formatter configurations
local function get_builtin_formatters()
	return {
		vim_builtin = {
			command = function()
				-- Use Vim's built-in formatting (gq command)
				vim.cmd("normal! ggVGgq")
				return nil -- No external command needed
			end,
			post_action = "none", -- Already formatted in-place
			success_message = "Vim built-in: Formatting complete",
			filetypes = {}, -- Can be used for any filetype when explicitly called
		},

		vim_indent = {
			command = function()
				-- Use Vim's built-in indentation (gg=G)
				vim.cmd("normal! gg=G")
				return nil
			end,
			post_action = "none",
			success_message = "Vim indent: Formatting complete",
			filetypes = {}, -- Can be used for any filetype when explicitly called
		},
	}
end

-- Default configuration structure
---@return FormatterPluginConfig config Default plugin configuration
local function get_default_config()
	return {
		-- Core settings
		keybinding = "<leader>f",

		-- External formatters will be injected here from pluginconf
		-- Each formatter should have: command, filetypes, success_message, post_action, format_on_save (optional)
		formatters = {},
	}
end

-- Main setup function
---@param opts FormatterPluginConfig? Optional configuration to override defaults
function M.setup(opts)
	-- Merge user config with defaults
	M.config = vim.tbl_deep_extend("force", get_default_config(), opts or {})

	-- Always include built-in Vim formatters
	local builtin_formatters = get_builtin_formatters()
	M.config.formatters = vim.tbl_deep_extend("force", builtin_formatters, M.config.formatters or {})

	-- Setup all components
	setup_commands()
	setup_keybinding()
	setup_format_on_save()

	-- Log successful setup
	local external_count = vim.tbl_count(M.config.formatters) - vim.tbl_count(builtin_formatters)
	vim.notify(
		string.format("Formatter plugin initialized with %d external formatters", external_count),
		vim.log.levels.INFO
	)
end

return M
