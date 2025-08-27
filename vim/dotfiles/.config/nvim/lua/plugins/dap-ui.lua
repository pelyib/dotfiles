local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend("force", {
	"rcarriga/nvim-dap-ui",
	enabled = false,
	lazy = true,
	cmd = { "DapUI" },
	tag = "v3.9.1",
	dependencies = {
		"mfussenegger/nvim-dap",
	},
    config = true,
}, pluginconf.dapui or {})
