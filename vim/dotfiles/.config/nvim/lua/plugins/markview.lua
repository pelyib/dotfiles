local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend("force", {
    "OXY2DEV/markview.nvim",
    lazy = false,
    enabled = false,
    tag = "v27.0.0",
}, pluginconf.markview or {})
