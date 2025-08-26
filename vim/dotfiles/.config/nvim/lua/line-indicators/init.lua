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

-- Get buffer lines as a hash for comparison
local function get_buffer_hash(bufnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	return table.concat(lines, "\n")
end

-- Initialize buffer state
local function init_buffer_state(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	buffer_states[bufnr] = {
		baseline = get_buffer_hash(bufnr),
		signs_placed = {},
		last_update = 0,
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

	local current_hash = get_buffer_hash(bufnr)
	local state = buffer_states[bufnr]

	-- No changes detected - only clear if we know the buffer was just saved
	if current_hash == state.baseline then
		return
	end

	-- Parse lines for diff
	local baseline_lines = vim.split(state.baseline, "\n", { plain = true })
	local current_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

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

-- Update baseline after save
local function update_baseline(bufnr)
	if not buffer_states[bufnr] then
		return
	end

	buffer_states[bufnr].baseline = get_buffer_hash(bufnr)
	clear_buffer_signs(bufnr)
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

	-- Define signs
	vim.fn.sign_define(signs.line_added, {
		text = M.config.icons.added,
		texthl = "DiffAdd",
		numhl = "DiffAdd",
	})

	vim.fn.sign_define(signs.line_modified, {
		text = M.config.icons.modified,
		texthl = "DiffChange",
		numhl = "DiffChange",
	})

	vim.fn.sign_define(signs.line_deleted, {
		text = M.config.icons.deleted,
		texthl = "DiffDelete",
		numhl = "DiffDelete",
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
			end
		end,
	})

	-- Track changes
	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
		group = group,
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()
			if vim.bo[bufnr].buftype == "" then
				debounced_update()
			end
		end,
	})

	-- Update baseline after save
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = group,
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()
			update_baseline(bufnr)
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
end

return M
