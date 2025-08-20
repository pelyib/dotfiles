local M = {}

-- Cache configuration
local cache = {
    git_branch = {
        value = nil,
        last_update = 0,
        cwd = nil,
        ttl = 5000, -- 5 seconds
    },
    file_status = {
        value = nil,
        last_update = 0,
        file_path = nil,
        ttl = 2000, -- 2 seconds (faster refresh for file changes)
    },
    code_context = {
        value = nil,
        last_bufnr = -1,
        last_line = -1,
        last_col = -1,
    }
}

-- Configuration
M.config = {
    icons = {
        git = "󰊢 ",
        separator = " │ ",
        modified = " ",
        readonly = " ",
        location = "󰍉 ",
        percent = "󰏰 ",
        line_col = "󰌒 ",
    },
    code_context = {
        max_items = 3,
        languages = {
            php = { "namespace", "class", "method" },
            javascript = { "class", "method" },
            typescript = { "class", "method" },
            lua = { "function" },
            python = { "class", "method" },
            go = { "function" },
        }
    }
}

-- Git branch with intelligent caching
M.get_git_branch = function()
    local current_time = vim.loop.now()
    local current_cwd = vim.fn.getcwd()
    
    -- Check if cache is valid
    if cache.git_branch.value and 
       cache.git_branch.cwd == current_cwd and
       (current_time - cache.git_branch.last_update) < cache.git_branch.ttl then
        return cache.git_branch.value
    end
    
    -- Update cache
    local result = ""
    local branch_cmd = "git branch --show-current 2>/dev/null"
    local handle = io.popen(branch_cmd)
    
    if handle then
        local branch = handle:read("*a")
        handle:close()
        
        if branch and branch ~= "" then
            branch = branch:gsub("\n", "")
            result = M.config.icons.git .. branch
        end
    end
    
    -- Cache the result
    cache.git_branch.value = result
    cache.git_branch.last_update = current_time
    cache.git_branch.cwd = current_cwd
    
    return result
end

-- Get project root folder name
M.get_project_root = function()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

-- Get relative file path with file icon
M.get_file_path = function()
    if vim.bo.buftype == "nofile" or vim.bo.buftype == "quickfix" then
        return ""
    end
    local path = vim.fn.expand("%:.")
    if path == "" then
        return ""
    end
    return path
end

-- Get file status indicators using git status with caching
M.get_file_status = function()
    local current_file = vim.fn.expand("%:.")
    if current_file == "" then
        return ""
    end
    
    local current_time = vim.loop.now()
    
    -- Check if cache is valid
    if cache.file_status.value and 
       cache.file_status.file_path == current_file and
       (current_time - cache.file_status.last_update) < cache.file_status.ttl then
        -- Add readonly check (not cached as it rarely changes)
        local result = cache.file_status.value
        if vim.bo.readonly then
            result = result .. M.config.icons.readonly
        end
        return result
    end
    
    local status = ""
    
    -- Check if file is modified using git status
    local git_cmd = string.format("git status --porcelain %s 2>/dev/null", vim.fn.shellescape(current_file))
    local handle = io.popen(git_cmd)
    
    if handle then
        local git_output = handle:read("*a")
        handle:close()
        
        -- Check if file has modifications
        if git_output and git_output ~= "" then
            local git_status = git_output:sub(1, 2)
            -- M = modified, A = added, D = deleted, R = renamed, etc.
            if git_status:match("[MAD]") then
                status = status .. M.config.icons.modified
            end
        end
    end
    
    -- Cache the git status result
    cache.file_status.value = status
    cache.file_status.last_update = current_time
    cache.file_status.file_path = current_file
    
    -- Add readonly check (not cached)
    if vim.bo.readonly then
        status = status .. M.config.icons.readonly
    end
    
    return status
end

-- Enhanced code context with language-specific filtering
M.get_code_context = function()
    local navic_ok, navic = pcall(require, "nvim-navic")
    if not navic_ok then
        return ""
    end
    
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line, col = cursor[1], cursor[2]
    
    -- Check if cache is valid (same buffer and position)
    if cache.code_context.last_bufnr == bufnr and
       cache.code_context.last_line == line and
       cache.code_context.last_col == col and
       cache.code_context.value then
        return cache.code_context.value
    end
    
    local code_data = navic.get_data()
    if not code_data or #code_data == 0 then
        cache.code_context.value = ""
        return ""
    end
    
    local filetype = vim.bo.filetype
    local lang_config = M.config.code_context.languages[filetype]
    local context_parts = {}
    
    -- Filter and format based on language configuration
    local max_items = math.min(M.config.code_context.max_items, #code_data)
    for i = 1, max_items do
        local item = code_data[i]
        if item and item.name then
            -- Language-specific filtering
            if lang_config then
                local item_type = item.type and item.type:lower()
                local should_include = false
                
                for _, allowed_type in ipairs(lang_config) do
                    if item_type and item_type:find(allowed_type) then
                        should_include = true
                        break
                    end
                end
                
                if should_include then
                    table.insert(context_parts, (item.icon or "") .. item.name)
                end
            else
                -- Default behavior - include all items
                table.insert(context_parts, (item.icon or "") .. item.name)
            end
        end
    end
    
    local result = ""
    if #context_parts > 0 then
        result = "::" .. table.concat(context_parts, ".")
    end
    
    -- Update cache
    cache.code_context.value = result
    cache.code_context.last_bufnr = bufnr
    cache.code_context.last_line = line
    cache.code_context.last_col = col
    
    return result
end

-- Get current line length for cursor position context
M.get_line_info = function()
    return #vim.fn.getline('.')
end

-- Format statusline for special buffers
M.format_special_buffer = function()
    local branch = M.get_git_branch()
    local root = M.get_project_root()
    
    return string.format(
        "%s%s[%s]",
        branch,
        branch ~= "" and M.config.icons.separator or "",
        root
    )
end

-- Format statusline for regular files
M.format_regular_buffer = function()
    local branch = M.get_git_branch()
    local root = M.get_project_root()
    local file_path = M.get_file_path()
    local file_status = M.get_file_status()
    local code_context = M.get_code_context()
    local line_length = M.get_line_info()
    
    local left_section = string.format(
        "%s%s[%s] %s%s%s",
        branch,
        branch ~= "" and M.config.icons.separator or "",
        root,
        file_status,
        file_path,
        code_context
    )
    
    -- Right-aligned section with cursor info and icons
    local right_section = string.format(
        "%s%%l / %%L%s%s%%v-%d%s%s%%p%%",
        M.config.icons.location,
        M.config.icons.separator,
        M.config.icons.line_col,
        line_length,
        M.config.icons.separator,
        M.config.icons.percent
    )
    
    return left_section .. " %=" .. right_section
end

-- Main statusline calculation function
M.calc = function()
    if vim.bo.buftype == "nofile" or vim.bo.buftype == "quickfix" then
        return M.format_special_buffer()
    else
        return M.format_regular_buffer()
    end
end

-- Clear cache when needed (useful for manual refresh)
M.clear_cache = function()
    cache.git_branch.value = nil
    cache.git_branch.last_update = 0
    cache.file_status.value = nil
    cache.file_status.last_update = 0
    cache.code_context.value = nil
    cache.code_context.last_bufnr = -1
end

-- Setup function for configuration
M.setup = function(opts)
    if opts then
        M.config = vim.tbl_deep_extend("force", M.config, opts)
    end
    
    -- Auto-clear git cache when changing directories
    vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
            cache.git_branch.value = nil
            cache.git_branch.cwd = nil
        end,
    })
    
    -- Auto-clear file status cache when files are written or buffers change
    vim.api.nvim_create_autocmd({"BufWritePost", "BufEnter"}, {
        callback = function()
            cache.file_status.value = nil
            cache.file_status.last_update = 0
        end,
    })
    
    -- Auto-clear code context cache on cursor move (with debouncing)
    local timer = vim.loop.new_timer()
    vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
        callback = function()
            timer:stop()
            timer:start(100, 0, vim.schedule_wrap(function()
                cache.code_context.last_line = -1
                cache.code_context.last_col = -1
            end))
        end,
    })
end

return M
