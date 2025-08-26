local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend("force", {
	name = "phptestrunner",
	enabled = false,
	lazy = true,
	dir = vim.fn.stdpath("config") .. "/lua/phptestrunner",
	opts = {},
	config = true,
	main = "phptestrunner",
	keys = {
		{
			"ptf",
			mode = { "n" },
			function()
				require("phptestrunner").runOneClass()
			end,
			desc = "Run PHP test file",
		},
		{
			"ptc",
			mode = { "n" },
			function()
				require("phptestrunner").runOneCase()
			end,
			desc = "Run PHP test case",
		},
		{
			"pts",
			mode = { "n" },
			function()
				local suites = {}
				local p = io.popen('find "' .. vim.fn.getcwd() .. '/test/suite" -type d -depth 1')
				if p == nil then
					vim.notify(
						"No suite in the test/suite directory",
						vim.log.levels.INFO,
						{ title = "PHP test runner" }
					)
					return
				end
				for file in p:lines() do
					table.insert(suites, vim.fn.fnamemodify(file, ":t"))
				end
				vim.ui.select(suites, { prompt = "Select the suite to run" }, function(choice)
					if choice == nil then
						return
					end
					require("phptestrunner").runSuite(choice)
				end)
			end,
			desc = "Run PHP test case",
		},
	},
	dependencies = {
		"rcarriga/nvim-notify",
	},
}, pluginconf.php_test_runner or {})
