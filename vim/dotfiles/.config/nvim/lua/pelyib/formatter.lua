local M = {}

-- Store formatter configurations for different filetypes
M.formatters = {
    -- Default formatters configuration will be populated during setup
}

-- Map of filetype to formatter tool
M.filetype_formatters = {
    -- Will be populated during setup based on configuration
}

-- Execute formatter for the current buffer based on its filetype
function M.format_buffer()
    local filetype = vim.bo.filetype
    local formatter = M.filetype_formatters[filetype]

    if not formatter then
        vim.notify('No formatter configured for filetype: ' .. filetype, 'warn')
        return
    end

    -- Get the formatter function
    local format_func = M.formatters[formatter]
    if not format_func then
        vim.notify('Formatter not found: ' .. formatter, 'error')
        return
    end
    
    -- Execute the formatter
    local success, msg = pcall(format_func)
    if not success then
        vim.notify('Formatting failed: ' .. msg, 'error')
    end
end

-- Setup formatters based on configuration
function M.setup_formatters(config)
    -- Initialize formatters with default implementations
    M.formatters = {
        -- PHP CS Fixer
        phpcsfixer = function()
            local cmd = config.phpcsfixer.cmd or "php-cs-fixer"
            local args = config.phpcsfixer.args or {"fix", vim.fn.expand("%")}
            
            local output = vim.fn.system(cmd .. " " .. table.concat(args, " "))
            if vim.v.shell_error ~= 0 then
                error(output)
            end
            
            -- Reload the buffer to show changes
            vim.cmd("e!")
            vim.notify('PHP CS Fixer: Formatting complete', 'info')
        end,
        
        -- Prettier for JavaScript/TypeScript
        prettier = function()
            local cmd = config.prettier.cmd or "prettier"
            local args = config.prettier.args or {"--write", vim.fn.expand("%")}
            
            local output = vim.fn.system(cmd .. " " .. table.concat(args, " "))
            if vim.v.shell_error ~= 0 then
                error(output)
            end
            
            -- Reload the buffer to show changes
            vim.cmd("e!")
            vim.notify('Prettier: Formatting complete', 'info')
        end,
        
        -- Stylua for Lua
        stylua = function()
            local cmd = config.stylua.cmd or "stylua"
            local args = config.stylua.args or {vim.fn.expand("%")}
            
            local output = vim.fn.system(cmd .. " " .. table.concat(args, " "))
            if vim.v.shell_error ~= 0 then
                error(output)
            end
            
            -- Reload the buffer to show changes
            vim.cmd("e!")
            vim.notify('Stylua: Formatting complete', 'info')
        end,
        
        -- Black for Python
        black = function()
            local cmd = config.black.cmd or "black"
            local args = config.black.args or {vim.fn.expand("%")}
            
            local output = vim.fn.system(cmd .. " " .. table.concat(args, " "))
            if vim.v.shell_error ~= 0 then
                error(output)
            end
            
            -- Reload the buffer to show changes
            vim.cmd("e!")
            vim.notify('Black: Formatting complete', 'info')
        end,
        
        -- Gofmt for Go
        gofmt = function()
            local cmd = config.gofmt.cmd or "gofmt"
            local args = config.gofmt.args or {"-w", vim.fn.expand("%")}
            
            local output = vim.fn.system(cmd .. " " .. table.concat(args, " "))
            if vim.v.shell_error ~= 0 then
                error(output)
            end
            
            -- Reload the buffer to show changes
            vim.cmd("e!")
            vim.notify('Gofmt: Formatting complete', 'info')
        end,
    }
    
    -- Map filetypes to formatters based on configuration
    M.filetype_formatters = {}
    for filetype, formatter in pairs(config.filetype_formatters or {}) do
        M.filetype_formatters[filetype] = formatter
    end
end

-- Setup commands and keybindings
function M.setup_commands()
    -- Create command to format current buffer
    vim.api.nvim_create_user_command('Format', function()
        M.format_buffer()
    end, {})
    
    -- Set up format on save if enabled
    if M.config.format_on_save then
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = M.config.format_on_save_filetypes or "*",
            callback = function()
                if M.config.format_on_save then
                    M.format_buffer()
                end
            end,
        })
    end
    
    -- Set up keybinding if enabled
    if M.config.keybinding and M.config.keybinding ~= "" then
        vim.keymap.set('n', M.config.keybinding, function()
            M.format_buffer()
        end, { noremap = true, silent = true })
    end
end

-- Main setup function
function M.setup()
    -- Get configuration from pluginconf
    local pluginconf_ok, pluginconf = pcall(require, 'pelyib.pluginconf')
    if not pluginconf_ok then
        vim.notify("Failed to load pluginconf for formatter", vim.log.levels.ERROR)
        return
    end
    local config = pluginconf.config.patched
    M.config = config.formatter or {}
    
    -- Skip setup if not enabled
    if not M.config.enabled then
        return
    end
    
    -- Setup formatters based on configuration
    M.setup_formatters(M.config)
    
    -- Setup commands and keybindings
    M.setup_commands()
    
    -- Log successful setup
    vim.notify('Formatter plugin initialized', 'info')
end

return M
