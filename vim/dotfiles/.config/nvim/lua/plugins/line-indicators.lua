local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend("force", {
	name = "line-indicators",
	enabled = false,
	lazy = true,
	dir = vim.fn.stdpath("config") .. "/lua/line-indicators",
	main = "line-indicators",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		debounce_ms = 150,
		auto_enable_signcolumn = true,
	},
	config = true,
}, pluginconf.lineindicators or {})
