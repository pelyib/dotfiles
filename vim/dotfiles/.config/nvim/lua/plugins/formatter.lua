local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend("force", {
	"pelyib/formatter",
	enabled = false,
	dir = vim.fn.stdpath("config") .. "/lua/pelyib",
	config = function()
		require("pelyib.formatter").setup()
	end,
	dependencies = {
		"rcarriga/nvim-notify",
	},
}, pluginconf.formatter or {})
