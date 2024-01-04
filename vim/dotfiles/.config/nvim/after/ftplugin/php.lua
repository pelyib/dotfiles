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

-- Run a test case
vim.keymap.set('n', 'ptt', function ()
    testRunner.runOneCase()
end)

-- Run all cases in the file
vim.keymap.set('n', 'pta', function ()
    testRunner.runOneClass()
end)

-- Run a suite
vim.keymap.set('n', 'pts', function ()
    -- TODO read test/suite folder for the list [botond.pelyi]
    vim.ui.select({"integration", "unit"}, {prompt = "Select the suite to run"}, function (choice)
        if choice == nil then
            return
        end
        testRunner.runSuite(choice)
    end)
end)
