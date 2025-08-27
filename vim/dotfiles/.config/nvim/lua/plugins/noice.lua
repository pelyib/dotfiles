local pluginconf = require("pelyib.pluginconf").config.patched

return vim.tbl_deep_extend("force", {
	"folke/noice.nvim",
	enabled = false,
	tag = "v4.10.0",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
    config = true,
}, pluginconf.noice or {})
