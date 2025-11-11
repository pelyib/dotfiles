local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend("force", {
	"mfussenegger/nvim-dap",
	enabled = false,
	lazy = true,
	cmd = { "DapContinue", "DapToggleBreakpoint", "DapStepOver", "DapStepInto", "DapStepOut" },
	tag = "0.7.0",
	opts = {
		clients = {},
	},
	config = function(_, opts)
		local dap = require("dap")
		if opts.clients then
			for name, client in pairs(opts.clients) do
				dap.adapters[name] = client.adapter
				dap.configurations[name] = client.configurations
			end
		end
	end,
}, pluginconf.dap or {})
