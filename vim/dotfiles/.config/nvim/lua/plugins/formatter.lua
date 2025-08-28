local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend("force", {
	"pelyib/formatter",
	enabled = false,
	lazy = true,
	dir = vim.fn.stdpath("config") .. "/lua/formatter",
	config = true,
	main = "formatter",
	keys = {
		{
			"csf",
			mode = { "n" },
			function()
				require("formatter").format_buffer()
			end,
			desc = "Format current buffer",
		},
	},
	dependencies = {
		"rcarriga/nvim-notify",
	},
}, pluginconf.formatter or {})
