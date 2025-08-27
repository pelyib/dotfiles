local M = {}

-- Buffer state tracking
local buffer_states = {}


-- Configuration
M.config = {
	icons = {
		added = "+",
		modified = "~",
		deleted = "-",
	},
	colors = {
		added = "#10b981", -- Green
		modified = "#3b82f6", -- Blue
		deleted = "#ef4444", -- Red
	},
	debounce_ms = 150,
	auto_enable_signcolumn = true,
}

-- Sign definitions
local signs = {
	line_added = "LineIndicatorAdded",
	line_modified = "LineIndicatorModified",
	line_deleted = "LineIndicatorDeleted",
}

-- Debounce timer
local debounce_timer = nil

-- Get git diff for the file (working directory vs HEAD)
local function get_git_diff(file_path)
	if not file_path or file_path == "" then
		return nil
	end

	local relative_path = vim.fn.fnamemodify(file_path, ":.")
	-- Compare working directory vs HEAD (last commit)
	local handle = io.popen("git diff HEAD -- " .. vim.fn.shellescape(relative_path) .. " 2>/dev/null")
	if not handle then
		return nil
	end

	local diff_output = handle:read("*a")
	local success = handle:close()

	-- If command failed or file doesn't exist in HEAD, return empty (no changes to show)
	if not success then
		return ""
	end

	return diff_output
end

-- Check if file is in a git repository
local function is_git_repo(file_path)
	if not file_path or file_path == "" then
		return false
	end

	local handle = io.popen(
		"cd " .. vim.fn.shellescape(vim.fn.fnamemodify(file_path, ":h")) .. " && git rev-parse --git-dir 2>/dev/null"
	)
	if not handle then
		return false
	end

	local result = handle:read("*a")
	local success = handle:close()

	return success and result and result:match("%S")
end

-- Initialize buffer state
local function init_buffer_state(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	local file_path = vim.api.nvim_buf_get_name(bufnr)
	if not is_git_repo(file_path) then
		return
	end

	buffer_states[bufnr] = {
		signs_placed = {},
		last_update = 0,
		file_path = file_path,
	}

	-- Enable sign column if configured
	if M.config.auto_enable_signcolumn then
		vim.api.nvim_buf_set_option(bufnr, "signcolumn", "yes")
	end
end

-- Clear all signs for a buffer
local function clear_buffer_signs(bufnr)
	if not buffer_states[bufnr] then
		return
	end

	pcall(vim.fn.sign_unplace, signs.line_added, { buffer = bufnr, })
	pcall(vim.fn.sign_unplace, signs.line_modified, { buffer = bufnr, })
	pcall(vim.fn.sign_unplace, signs.line_deleted, { buffer = bufnr, })

	buffer_states[bufnr].signs_placed = {}
end

-- Place a sign at a specific line
local function place_sign(bufnr, line_nr, sign_type)
	if not buffer_states[bufnr] then
		return
	end

	local sign_name = signs[sign_type]
	if not sign_name then
		return
	end

	-- Remove existing sign at this line first
	pcall(vim.fn.sign_unplace, signs.line_added, { buffer = bufnr, id = line_nr })
	pcall(vim.fn.sign_unplace, signs.line_modified, { buffer = bufnr, id = line_nr })
	pcall(vim.fn.sign_unplace, signs.line_deleted, { buffer = bufnr, id = line_nr })

	-- Place new sign
	pcall(vim.fn.sign_place, line_nr, sign_name, sign_name, bufnr, { lnum = line_nr })
	buffer_states[bufnr].signs_placed[line_nr] = sign_type
end

-- Parse git diff output to extract changed lines
local function parse_git_diff(diff_output)
	local changes = {}
	
	if not diff_output or diff_output == "" then
		return changes
	end

	local current_line = 0
	for line in diff_output:gmatch("[^\r\n]+") do
		-- Parse hunk header: @@ -old_start,old_count +new_start,new_count @@
		local new_start, new_count = line:match("@@ %-%d+,?%d* %+(%d+),?(%d*) @@")
		if new_start then
			current_line = tonumber(new_start)
			new_count = new_count == "" and 1 or tonumber(new_count)
		elseif line:match("^%+") and not line:match("^%+%+%+") then
			-- Added line
			changes[current_line] = "line_added"
			current_line = current_line + 1
		elseif line:match("^%-") and not line:match("^%-%-%-") then
			-- Deleted line (mark at current position)
			changes[current_line] = "line_deleted"
			-- Don't increment current_line for deletions
		elseif line:match("^ ") then
			-- Unchanged line
			current_line = current_line + 1
		end
	end

	return changes
end

-- Update line indicators for a buffer
local function update_indicators(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	if not buffer_states[bufnr] then
		init_buffer_state(bufnr)
		return
	end

	local state = buffer_states[bufnr]
	
	-- Get git diff for this file
	local diff_output = get_git_diff(state.file_path)
	
	-- Clear existing signs first
	clear_buffer_signs(bufnr)
	
	-- If no diff output, file matches HEAD
	if not diff_output or diff_output == "" then
		print("No changes detected")
		return
	end

	print("Git diff detected, parsing changes...")
	
	-- Parse git diff to get changed lines
	local changes = parse_git_diff(diff_output)

	-- Place new signs
	for line_nr, change_type in pairs(changes) do
		place_sign(bufnr, line_nr, change_type)
	end

	state.last_update = vim.loop.now()
	print("Updated " .. vim.tbl_count(changes) .. " line indicators")
end

-- Debounced update function
local function debounced_update()
	if debounce_timer then
		debounce_timer:stop()
		debounce_timer:close()
	end

	debounce_timer = vim.loop.new_timer()
	debounce_timer:start(
		M.config.debounce_ms,
		0,
		vim.schedule_wrap(function()
			local bufnr = vim.api.nvim_get_current_buf()
			update_indicators(bufnr)
		end)
	)
end

-- Refresh git indicators (called after git operations)
local function refresh_git_indicators(bufnr)
	if not buffer_states[bufnr] then
		return
	end

	print("Refreshing Git indicators for buffer " .. bufnr)
	update_indicators(bufnr)
end

-- Cleanup buffer state
local function cleanup_buffer(bufnr)
	if buffer_states[bufnr] then
		clear_buffer_signs(bufnr)
		buffer_states[bufnr] = nil
	end
end

-- Setup function
function M.setup(opts)
	opts = opts or {}
	M.config = vim.tbl_deep_extend("force", M.config, opts)

	-- Create custom highlight groups using configurable colors
	vim.api.nvim_set_hl(0, "LineIndicatorAdded", { fg = M.config.colors.added })
	vim.api.nvim_set_hl(0, "LineIndicatorModified", { fg = M.config.colors.modified })
	vim.api.nvim_set_hl(0, "LineIndicatorDeleted", { fg = M.config.colors.deleted })

	-- Define signs
	vim.fn.sign_define(signs.line_added, {
		text = M.config.icons.added,
		texthl = "LineIndicatorAdded",
	})

	vim.fn.sign_define(signs.line_modified, {
		text = M.config.icons.modified,
		texthl = "LineIndicatorModified",
	})

	vim.fn.sign_define(signs.line_deleted, {
		text = M.config.icons.deleted,
		texthl = "LineIndicatorDeleted",
	})

	-- Setup autocmds
	local group = vim.api.nvim_create_augroup("LineIndicators", { clear = true })

	-- Initialize buffer state when entering buffers
	vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
		group = group,
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()
			if vim.bo[bufnr].buftype == "" then
				init_buffer_state(bufnr)
				-- Update indicators immediately for existing changes
				update_indicators(bufnr)
			end
		end,
	})

	-- Track changes
	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
		group = group,
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()
			if vim.bo[bufnr].buftype == "" and buffer_states[bufnr] then
				debounced_update()
			end
		end,
	})

	-- Refresh git baseline after potential git operations
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = group,
		callback = function()
			-- Small delay to allow git hooks to complete
			vim.defer_fn(function()
				local bufnr = vim.api.nvim_get_current_buf()
				if buffer_states[bufnr] then
					refresh_git_indicators(bufnr)
				end
			end, 100)
		end,
	})

	-- Cleanup on buffer delete
	vim.api.nvim_create_autocmd("BufDelete", {
		group = group,
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()
			cleanup_buffer(bufnr)
		end,
	})

	-- Refresh on focus gained (in case git state changed externally)
	vim.api.nvim_create_autocmd("FocusGained", {
		group = group,
		callback = function()
			-- Refresh all buffers when focus is gained
			for bufnr, _ in pairs(buffer_states) do
				if vim.api.nvim_buf_is_valid(bufnr) then
					refresh_git_indicators(bufnr)
				end
			end
		end,
	})

	-- Refresh when entering any buffer (catches git changes)
	vim.api.nvim_create_autocmd("BufEnter", {
		group = group,
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()
			if buffer_states[bufnr] then
				-- Small delay to avoid excessive refreshing
				vim.defer_fn(function()
					refresh_git_indicators(bufnr)
				end, 50)
			end
		end,
	})

	-- Add manual refresh command for debugging
	vim.api.nvim_create_user_command("LineIndicatorsRefresh", function()
		local bufnr = vim.api.nvim_get_current_buf()
		if buffer_states[bufnr] then
			print("Refreshing indicators for buffer " .. bufnr)
			refresh_git_indicators(bufnr)
		else
			print("No line indicators state for current buffer")
		end
	end, {})
end

return M
