local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

-- The statusline will registered by pelyib.vim plugin.
-- But if this is disabled then the statusline won't be updated since the statusline.setup registers the hooks.
return vim.tbl_deep_extend("force", {
	name = "statusline",
	main = "statusline",
	enabled = false,
	lazy = false,
	dir = vim.fn.stdpath("config") .. "/lua/statusline",
	config = true,
}, pluginconf.statusline or {})
