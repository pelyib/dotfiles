---@class M
---@field opts defaultOpts
local M = {
    notify = require("pelyib.notifier")
}

---@enum target
local target = {
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
        env = {"make", "env=test", "test.run"},
        framework = {},
        args = {
            ---@param tc testCase
            function (tc)
                local serializer = {
                    [target.METHOD] = function (tc)
                        return string.format("suite=\"%s:%s\"", vim.fn.expand("%:r"), tc.method)
                    end,
                    [target.CLASS] = function (tc)
                        return string.format("suite=\"%s\"", vim.fn.expand("%:r"))
                    end,
                    [target.SUITE] = function (tc)
                        return string.format("suite=\"%s\"", tc.suite)
                    end
                }

                local case = serializer[tc.target]
                if case then
                    return case(tc)
                end

                return ""
            end
        },
    }
}

local function runTest(command)
    M.notify.info(command)
    require("pelyib.shell-runner")(command)
end

---@return testCase
local function testCaseFactory()
    local bufnr = vim.api.nvim_get_current_buf()
    local tsUtils = require("nvim-treesitter.ts_utils")
    local node = tsUtils.get_node_at_cursor()
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
--    for key, section in pairs(commandEnv) do
    for _, section in pairs({"env", "framework", "args"}) do
        for _, item in pairs(commandEnv[section]) do
            if type(item) == "string" then
                table.insert(cmd, item)
            elseif type(item) == "function" then
                table.insert(cmd, item(tc))
            end
        end
    end

    return cmd
end

function M.setup(opts)
    local root = vim.fn.getcwd()
    opts = opts or {}
    M.opts = vim.tbl_deep_extend("force", defaultOpts, opts)
    if vim.fn.filereadable(vim.fn.expand(root .. '/vendor/bin/phpunit')) == 1 then
        M.opts.frameworks.phpunit.available = true
    end
    if vim.fn.filereadable(vim.fn.expand(root .. '/vendor/bin/codecept')) == 1 then
        M.opts.frameworks.codeception.available = true
    end
end

function M.runOneCase()
    local tc = testCaseFactory()
    if tc.class == nil or tc.method == nil then
        M.notify.info("Cursor is not in a test method")
        M.notify.info(tc)
        return
    end

    tc.target = target.METHOD

    M.notify.debug(string.format("Codeception: %s\nPhpUnit: %s", tostring(M.opts.frameworks.codeception.available), tostring(M.opts.frameworks.phpunit.available)))

    runTest(buildCommand(M.opts.command, tc))
end

function M.runOneClass()
    local tc = testCaseFactory()
    if tc.class == nil then
        M.notify.info("Cursor is not in a test class")
        return
    end

    tc.target = target.CLASS
    runTest(buildCommand(M.opts.command, tc))
end

function M.runSuite(suite)
    local tc = vim.tbl_extend("force", testCase, {suite = suite, target = target.SUITE})
    runTest(buildCommand(M.opts.command, tc))
end

return M
