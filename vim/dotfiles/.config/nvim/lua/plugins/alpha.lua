local pluginconf = require("pelyib.pluginconf").config.patched

return vim.tbl_deep_extend("force", {
	"goolord/alpha-nvim",
	enabled = false,
	commit = "29074ee",
	requires = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("alpha").setup(require("alpha.themes.startify").config)
	end,
}, pluginconf.alpha or {})
