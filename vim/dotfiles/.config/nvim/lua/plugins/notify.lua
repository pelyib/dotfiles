local pluginconf = require("pelyib.pluginconf").config.patched

return vim.tbl_deep_extend("force", {
	"rcarriga/nvim-notify",
	enabled = false,
	tag = "v3.13.5",
	opts = {
		background_colour = "#000000",
		top_down = false,
	},
}, pluginconf.notify or {})
