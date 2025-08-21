---@class M
---@field opts defaultOpts
local notify_ok, notify = pcall(require, "pelyib.notifier")
if not notify_ok then
    notify = {
        debug = function(msg) vim.notify(msg, vim.log.levels.DEBUG) end,
        info = function(msg) vim.notify(msg, vim.log.levels.INFO) end,
        warning = function(msg) vim.notify(msg, vim.log.levels.WARN) end,
        error = function(msg) vim.notify(msg, vim.log.levels.ERROR) end,
        setup = function() end,
    }
end

local M = {
    notify = notify
}

---@enum target
Target = {
    METHOD = 'method',
    CLASS = 'class',
    SUITE = 'suite',
}

---@class testCase
---@field class string|nil
---@field method string|nil
---@field suite string|nil
---@field isUnitTest boolean
---@field isCodeceptTest boolean
---@field target target|nil
local testCase = {
    class = nil,
    method = nil,
    suite = nil,
    isUnitTest = false,
    isCodeceptTest = false,
    target = nil,
}

---@class defaultOpts
local defaultOpts = {
    verbose = {
        enabled = false
    },
    frameworks = {
        phpunit = {
            enable = true,
            available = false,
            path = vim.fn.getcwd() .. '/vendor/bin/phpunit',
        },
        codeception = {
            enabled = true,
            available = false,
            path = vim.fn.getcwd() .. '/vendor/bin/codepect'
        }
    },
    command = {
        env = {"echo", "no command configured"},
        framework = {},
        args = {}
    },
    callback = function (code, success, error)
        if #success > 0 then
            local lines = {}
            for line in success:gmatch("[^\n]+") do
                if line:match("%S") then
                    table.insert(lines, line)
                end
            end

            local errors = lines[#lines]:match("Errors:%s*(%d+)")
            errors = tonumber(errors)
            if errors and errors > 0 then
                M.notify.error("Failed")
            else
                M.notify.info("Success")
            end
        end

        if #error > 0 then
            M.notify.warning(error)
        end

        if #success == 0 and #error == 0 then
            M.notify.info("No output of command, exit code: " .. code)
        end
    end
}

local function runTest(command, callback)
    M.notify.debug(command)
    local shell_runner_ok, shell_runner = pcall(require, "pelyib.shell-runner")
    if not shell_runner_ok then
        M.notify.error("Failed to load shell-runner module")
        return
    end
    shell_runner(command, callback)
end

---@return testCase
local function testCaseFactory()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local cursor_row, cursor_col = cursor[1] - 1, cursor[2] -- Convert to 0-indexed
    
    -- Get parser and root node
    local parser = vim.treesitter.get_parser(bufnr, "php")
    if not parser then
        M.notify.error("Failed to get treesitter parser for PHP")
        return testCase
    end
    
    local tree = parser:parse()[1]
    if not tree then
        M.notify.error("Failed to parse treesitter tree")
        return testCase
    end
    
    local root = tree:root()
    
    -- Define treesitter queries
    local method_query = vim.treesitter.query.parse("php", [[
        (method_declaration 
            name: (name) @method.name) @method.declaration
    ]])
    
    local class_query = vim.treesitter.query.parse("php", [[
        (class_declaration
            name: (name) @class.name) @class.declaration
    ]])
    
    local namespace_query = vim.treesitter.query.parse("php", [[
        (namespace_definition
            name: (namespace_name) @namespace.name) @namespace.declaration
    ]])
    
    local method_name, class_name, suite_name
    
    -- Find method containing cursor (search entire file, not just cursor row)
    for id, node, metadata in method_query:iter_captures(root, bufnr, 0, -1) do
        local capture_name = method_query.captures[id]
        if capture_name == "method.name" then
            -- Get the full method declaration (parent of the name node)
            local method_decl = node:parent()
            local decl_start_row, decl_start_col, decl_end_row, decl_end_col = method_decl:range()
            
            -- Check if cursor is anywhere within the method declaration (including body)
            if cursor_row >= decl_start_row and cursor_row <= decl_end_row then
                method_name = vim.treesitter.get_node_text(node, bufnr)
                break
            end
        end
    end
    
    -- Find class containing cursor
    for id, node, metadata in class_query:iter_captures(root, bufnr, 0, -1) do
        local capture_name = class_query.captures[id]
        if capture_name == "class.name" then
            local class_decl = node:parent()
            local decl_start_row, decl_start_col, decl_end_row, decl_end_col = class_decl:range()
            
            if cursor_row >= decl_start_row and cursor_row <= decl_end_row then
                class_name = vim.treesitter.get_node_text(node, bufnr)
                break
            end
        end
    end
    
    -- Find namespace (for suite detection)
    for id, node, metadata in namespace_query:iter_captures(root, bufnr, 0, -1) do
        local capture_name = namespace_query.captures[id]
        if capture_name == "namespace.name" then
            local namespace_text = vim.treesitter.get_node_text(node, bufnr)
            -- Look for "Test" in namespace segments
            if namespace_text:find("Test") then
                -- Extract suite name (segment after "Test")
                local segments = vim.split(namespace_text, "\\")
                for i, segment in ipairs(segments) do
                    if segment == "Test" and segments[i + 1] then
                        suite_name = segments[i + 1]
                        break
                    end
                end
            end
            break
        end
    end
    
    local tc = {
        class = class_name,
        method = method_name,
        suite = suite_name,
        isUnitTest = class_name and class_name:find("Test") ~= nil or false,
        isCodeceptTest = class_name and class_name:find("Cest") ~= nil or false,
    }

    M.notify.debug(string.format(
        "Class: %s\nMethod: %s\nSuite: %s\nIs unit test: %s\nIs Codeception: %s",
        tc.class or "nil",
        tc.method or "nil",
        tc.suite or "nil",
        tostring(tc.isUnitTest),
        tostring(tc.isCodeceptTest)
    ))

    return tc
end

---@param tc testCase
local function buildCommand(commandEnv, tc)
    local cmd = {}
    for _, section in pairs({"env", "framework", "args"}) do
        for _, item in pairs(commandEnv[section]) do
            if type(item) == "string" then
                table.insert(cmd, item)
            elseif type(item) == "function" then
                local result = item(tc)
                if (type(result) == "string") then
                    table.insert(cmd, result)
                elseif (type(result) == "table") then
                    for _, subItem in pairs(result) do
                        table.insert(cmd, subItem)
                    end
                end
            end
        end
    end

    return cmd
end

function M.setup(opts)
    local root = vim.fn.getcwd()
    M.opts = vim.tbl_deep_extend("force", defaultOpts, opts or {})
    if vim.fn.filereadable(vim.fn.expand(root .. '/vendor/bin/phpunit')) == 1 then
        M.opts.frameworks.phpunit.available = true
    end
    if vim.fn.filereadable(vim.fn.expand(root .. '/vendor/bin/codecept')) == 1 then
        M.opts.frameworks.codeception.available = true
    end
    M.notify.setup({vimNotOpts = {title="PHP test runner"}})
end

function M.runOneCase()
    local tc = testCaseFactory()
    if tc.class == nil or tc.method == nil then
        M.notify.info("Cursor is not in a test method")
        return
    end

    tc.target = Target.METHOD
    runTest(buildCommand(M.opts.command, tc), M.opts.callback)
end

function M.runOneClass()
    local tc = testCaseFactory()
    if tc.class == nil then
        M.notify.info("Cursor is not in a test class")
        return
    end

    tc.target = Target.CLASS
    runTest(buildCommand(M.opts.command, tc), M.opts.callback)
end

function M.runSuite(suite)
    local tc = vim.tbl_extend("force", testCase, {suite = suite, target = Target.SUITE})
    runTest(buildCommand(M.opts.command, tc), M.opts.callback)
end

return M
