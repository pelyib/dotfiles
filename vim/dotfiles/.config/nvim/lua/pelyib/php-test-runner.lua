---@class M
---@field opts defaultOpts
local M = {
    notify = require("pelyib.notifier")
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
    require("pelyib.shell-runner")(command, callback)
end

---@return testCase
local function testCaseFactory()
    local bufnr = vim.api.nvim_get_current_buf()
    local tsUtils = require("nvim-treesitter.ts_utils")
    local node = tsUtils.get_node_at_cursor()
    --@TODO: use the query solution instead of iterating over the nodes [botond.pelyi]
    -- local cRow, _ = unpack(vim.api.nvim_win_get_cursor(0))
    -- local parser = vim.treesitter.get_parser(bufnr, "php")
    -- local root = parser:parse()[1]:root()
    -- local tsQuery = require("vim.treesitter.query")
    -- local classNameQuery = tsQuery.parse_query('php', "(class_declaration body: (declaration_list (method_declaration name: (name) @methodsName )))")
    -- for _, found, _ in classNameQuery:iter_captures(root, bufnr, 0, cRow) do
    --     vim.notify(tsUtils.get_node_text(found, bufnr)[1])
    -- end

    local parent, method, class, suite

    repeat
        if node == nil then
            return testCase
        end

        parent = node:parent()
        node = parent

        if method == nil and node ~= nil and node:type() == "method_declaration" then
            for methodDecChild in node:iter_children() do
                if methodDecChild:type() == "name" then
                    method = methodDecChild
                end
            end
        end

        if class == nil and node ~= nil and node:type() == "class_declaration" then
            for classDecChild in node:iter_children() do
                if classDecChild:type() == "name" then
                    class = classDecChild
                    local sibling = class:prev_sibling()
                    repeat
                        if suite == nil and sibling:type() == "namespace_definition" then
                            for namespaceDefItem in sibling:child(1):iter_children() do
                                if tsUtils.get_node_text(namespaceDefItem, bufnr)[1] == "Test" then
                                    suite = namespaceDefItem:next_sibling():next_sibling()
                                end
                            end
                        end
                        sibling = sibling:prev_sibling()
                    until sibling == nil
                end
            end
        end
    until node:parent() == nil

    local tc = {
        class = class and tsUtils.get_node_text(class, bufnr)[1] or nil, -- TODO: refact the class, it should be an object, name and relative path [botond.pelyi]
        method = method and tsUtils.get_node_text(method, bufnr)[1] or nil,
        suite = suite and tsUtils.get_node_text(suite, bufnr)[1] or nil,
        isUnitTest = class and vim.fn.stridx(tsUtils.get_node_text(class, bufnr)[1], "Test") > -1 or false,
        isCodeceptTest = class and vim.fn.stridx(tsUtils.get_node_text(class, bufnr)[1], "Cest") > -1 or false,
    }

    M.notify.debug(string.format(
    "Class: %s\nMethod: %s\nSuite: %s\nIs unit test: %s\nIs Codeception: %s",
    tc.class,
    tc.method,
    tc.suite,
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
