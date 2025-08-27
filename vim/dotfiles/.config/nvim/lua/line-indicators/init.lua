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

-- Get git HEAD version of the file
local function get_git_head_content(file_path)
	if not file_path or file_path == "" then
		return nil
	end

	local handle = io.popen("git show HEAD:" .. vim.fn.shellescape(vim.fn.fnamemodify(file_path, ":.")))
	if not handle then
		return nil
	end

	local content = handle:read("*a")
	local success = handle:close()

	if not success or not content then
		return nil
	end

	return content
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

	local git_content = get_git_head_content(file_path)
	if not git_content then
		return
	end

	buffer_states[bufnr] = {
		git_baseline = git_content,
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

	for line_nr, _ in pairs(buffer_states[bufnr].signs_placed) do
		pcall(vim.fn.sign_unplace, signs.line_added, { buffer = bufnr, id = line_nr })
		pcall(vim.fn.sign_unplace, signs.line_modified, { buffer = bufnr, id = line_nr })
		pcall(vim.fn.sign_unplace, signs.line_deleted, { buffer = bufnr, id = line_nr })
	end

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

-- Simple diff implementation
local function compute_diff(baseline_lines, current_lines)
	local changes = {}
	local baseline_count = #baseline_lines
	local current_count = #current_lines
	local max_lines = math.max(baseline_count, current_count)

	for i = 1, max_lines do
		local baseline_line = baseline_lines[i]
		local current_line = current_lines[i]

		if baseline_line and current_line then
			-- Both lines exist
			if baseline_line ~= current_line then
				changes[i] = "line_modified"
			end
		elseif current_line and not baseline_line then
			-- Line added
			changes[i] = "line_added"
		elseif baseline_line and not current_line then
			-- Line deleted (mark the last existing line)
			if i > current_count then
				local mark_line = math.max(1, current_count)
				changes[mark_line] = "line_deleted"
			end
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
	local current_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local current_content = table.concat(current_lines, "\n")
	
	-- Add final newline if the file ends with one (to match git output)
	if vim.bo[bufnr].eol and #current_lines > 0 then
		current_content = current_content .. "\n"
	end

	-- Compare against git baseline
	print("Current content length: " .. #current_content)
	print("Git baseline length: " .. #state.git_baseline)
	print("Content matches: " .. tostring(current_content == state.git_baseline))
	
	if current_content == state.git_baseline then
		print("Contents match - clearing signs")
		clear_buffer_signs(bufnr)
		return
	end
	
	print("Contents differ - updating signs")

	-- Parse lines for diff
	local baseline_lines = vim.split(state.git_baseline, "\n", { plain = true })

	-- Compute differences
	local changes = compute_diff(baseline_lines, current_lines)

	-- Clear existing signs
	clear_buffer_signs(bufnr)

	-- Place new signs
	for line_nr, change_type in pairs(changes) do
		place_sign(bufnr, line_nr, change_type)
	end

	state.last_update = vim.loop.now()
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

-- Refresh git baseline (called after git operations)
local function refresh_git_baseline(bufnr)
	if not buffer_states[bufnr] then
		return
	end

    update_indicators(bufnr)

	-- local state = buffer_states[bufnr]
	-- local new_git_content = get_git_head_content(state.file_path)
	-- if new_git_content then
	-- 	print("Old baseline length: " .. #state.git_baseline)
	-- 	print("New baseline length: " .. #new_git_content)
	-- 	state.git_baseline = new_git_content
	-- 	update_indicators(bufnr)
	-- 	print("Baseline updated and indicators refreshed")
	-- else
	-- 	print("Failed to get new git content for: " .. state.file_path)
	-- end
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
					refresh_git_baseline(bufnr)
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
					refresh_git_baseline(bufnr)
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
					refresh_git_baseline(bufnr)
				end, 50)
			end
		end,
	})

	-- Add manual refresh command for debugging
	vim.api.nvim_create_user_command("LineIndicatorsRefresh", function()
		local bufnr = vim.api.nvim_get_current_buf()
		if buffer_states[bufnr] then
			print("Refreshing indicators for buffer " .. bufnr)
			refresh_git_baseline(bufnr)
		else
			print("No line indicators state for current buffer")
		end
	end, {})
end

return M
