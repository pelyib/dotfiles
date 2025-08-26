vim.keymap.set("n", "<leader>pn", function()
	local isInterface = vim.fn.stridx(vim.fn.expand("%"), "Interface") > -1
	local isAbstract = vim.fn.stridx(vim.fn.expand("%"), "Abstract") > -1
	-- TODO: create abstract template, by default Phpactor does not handle it [botond.pelyi]
	local variant = isInterface and "interface" or isAbstract and "abstract" or "default"

	vim.api.nvim_call_function("phpactor#rpc", {
		"class_new",
		{
			current_path = vim.api.nvim_call_function("phpactor#_path", {}),
			variant = variant,
		},
	})
end)

-- local testRunner_ok, testRunner = pcall(require, "pelyib.php-test-runner")
-- if not testRunner_ok then
--     return
-- end

-- Run a suite
-- vim.keymap.set('n', 'pts', function ()
--     local suites = {}
--     local p = io.popen('find "' .. vim.fn.getcwd() ..'/test/suite" -type d -depth 1')
--     if p == nil then
--         vim.notify("No suite in the test/suite directory", vim.log.levels.INFO, {title = "PHP test runner"})
--         return
--     end
--     for file in p:lines() do
--         table.insert(suites, vim.fn.fnamemodify(file, ":t"))
--     end
--     vim.ui.select(suites, {prompt = "Select the suite to run"}, function (choice)
--         if choice == nil then
--             return
--         end
--         testRunner.runSuite(choice)
--     end)
-- end)
