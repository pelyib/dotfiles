local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend("force", {
	"Exafunction/codeium.nvim",
	enabled = false,
	lazy = true,
	event = "InsertEnter",
	commit = "d3b88eb3aa1de6da33d325c196b8a41da2bcc825",
	config = true,
}, pluginconf.codeium or {})
