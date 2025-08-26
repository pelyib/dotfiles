local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend("force", {
	name = "line-indicators",
	enabled = true,
	lazy = false,
	dir = vim.fn.stdpath("config") .. "/lua/line-indicators",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		icons = {
			added = "+",
			modified = "~",
			deleted = "-",
		},
		debounce_ms = 150,
		auto_enable_signcolumn = true,
	},

	config = function(_, opts)
		require("line-indicators").setup(opts)
	end,
}, pluginconf.lineindicators or {})
