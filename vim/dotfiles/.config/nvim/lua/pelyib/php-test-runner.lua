---@class M
---@field opts opts
local M = {
}

---@class opts
local opts = {
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
}

---@class runner
local runner = {
    LOCAL = 'local',
    MAKE = 'make',
}

---@class testCase
---@field class string
---@field method string
---@field suite string
---@field isUnitTest boolean
---@field isCodeceptTest boolean
local testCase = {}

local function sendNotification(message)
    if M.opts.verbose.enabled then
        vim.notify(vim.inspect(message), vim.log.levels.INFO, {title = "PHP test runner"} )
    end
end

local function runTest(command)
    -- to call external commands
    -- vim.fn.system("put here the command")
    sendNotification(command)
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
            return {}
        end

        parent = node:parent()
        node = parent

        if method == nil and node:type() == "method_declaration" then
            method = node
        end

        if class == nil and node:type() == "class_declaration" then
            class = node
            local sibling = class:prev_sibling()
            repeat
                if suite == nil and sibling:type() == "namespace_definition" then
                    for item in sibling:child(1):iter_children() do
                        if tsUtils.get_node_text(item, bufnr)[1] == "Test" then
                            suite = item:next_sibling():next_sibling()
                        end
                    end
                end
                sibling = sibling:prev_sibling()
            until sibling == nil
        end
    until node:parent() == nil

    if method == nil or class == nil then
        sendNotification("Could not find test case")
    end

    local tc = {
        class = tsUtils.get_node_text(class:child(1), bufnr)[1], -- TODO: refact the class, it should be an object, name and relative path [botond.pelyi]
        method = tsUtils.get_node_text(method:child(2), bufnr)[1],
        suite = tsUtils.get_node_text(suite, bufnr)[1],
        isUnitTest = vim.fn.stridx(tsUtils.get_node_text(class:child(2), bufnr)[1], "Test") > -1,
        isCodeceptTest = vim.fn.stridx(tsUtils.get_node_text(class:child(2), bufnr)[1], "Cest") > -1,
    }

    sendNotification(string.format(
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
local function buildCommand(tc)
    -- TODO: need some parameter to build the command [botond.pelyi]
    return {
        "make",
        "env=test",
        "test",
        string.format("test=\"%s:%s\"", vim.fn.expand("%:r"), tc.method)
    }
end

function M.setup(commandMaker)
    local root = vim.fn.getcwd()
    M.opts = opts
    if vim.fn.filereadable(vim.fn.expand(root .. '/vendor/bin/phpunit')) == 1 then
        M.opts.frameworks.phpunit.available = true
    end
    if vim.fn.filereadable(vim.fn.expand(root .. '/vendor/bin/codecept')) == 1 then
        M.opts.frameworks.codeception.available = true
    end
    -- if commandMaker ~= nil then
    --     M.commandMaker = commandMaker
    -- end
end

function M.runOneCase()
    local tc = testCaseFactory()

    -- notify.notify(
    -- string.format("Codeception: %s\nPhpUnit: %s", tostring(M.opts.frameworks.codeception.available), tostring(M.opts.frameworks.phpunit.available)),
    -- vim.log.levels.INFO,
    -- notifyOpts
    -- )

    runTest(buildCommand(tc))
end

function M.runOneFile()
end

function M.runSuite(suite)
end

return M
