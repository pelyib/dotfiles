local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend("force", {
	"rachartier/tiny-inline-diagnostic.nvim",
	commit = "6e37efc9d16186c21a1cf0e8385b10f673ec582e",
	event = "VeryLazy",
	priority = 1000,
	config = function()
		require("tiny-inline-diagnostic").setup()
		vim.diagnostic.config({ virtual_text = false })
	end,
}, pluginconf.tinyonlinedeiagnostic or {})
