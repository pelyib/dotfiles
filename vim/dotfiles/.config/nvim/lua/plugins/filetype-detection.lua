local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend("force", {
	name = "filetype-detection",
	enabled = true,
	lazy = false,
	dir = vim.fn.stdpath("config") .. "/lua/filetype-detection",
	main = "filetype-detection",
	event = { "BufReadPost", "BufNewFile" },
	config = true,
}, pluginconf.filetype_detection or {})
