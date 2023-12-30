vim.keymap.set('n', '<leader>pn', function ()
    local isInterface = vim.fn.stridx(vim.fn.expand('%'), 'Interface') > -1
    local isAbstract = vim.fn.stridx(vim.fn.expand('%'), 'Abstract') > -1
    -- TODO: create abstract template, by default Phpactor does not handle it [botond.pelyi]
    local variant = isInterface and 'interface' or isAbstract and 'abstract' or 'default'

    vim.api.nvim_call_function(
    'phpactor#rpc',
    {
        'class_new',
        {
            current_path = vim.api.nvim_call_function('phpactor#_path', {}),
            variant = variant
        }
    }
    )
end)
vim.keymap.set('n', 'csf', function ()
    vim.api.nvim_call_function('PhpCsFixerFixFile', {})
end)

local testRunner = require("pelyib.php-test-runner")
testRunner.setup()

-- TODO: run test method
-- unit test criteria: current line is a "function" + method name starts with "test" + the file name ends with "Test"
-- API or other tests: current line is a "function" + method is public + the file name ends with "Cest"
-- suite: check the file path

-- Run a test case
vim.keymap.set('n', 'ptt', function ()
    testRunner.runOneCase()
end)

-- Run all cases in the file
vim.keymap.set('n', 'pta', function ()
    testRunner.runOneFile()
end)

-- Run a suite
vim.keymap.set('n', 'pts', function ()
    -- TODO: display the available suite list, read the selected one and call the test runner [botond.pelyi]
    testRunner.runSuite("unit")
end)
