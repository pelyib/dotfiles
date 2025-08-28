local pluginconfig = require("pelyib.pluginconf").config.patched

return vim.tbl_deep_extend("force", {
	"stevearc/dressing.nvim",
	enabled = false,
	tag = "v2.1.0",
}, pluginconfig.dressing or {})
