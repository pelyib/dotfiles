local pluginconf = require("pelyib.pluginconf").config.patched

return vim.tbl_deep_extend("force", {
	"folke/lazydev.nvim",
	enabled = false,
	tag = "v1.6.0",
	ft = "lua",
	opts = {
		library = {
			{ path = "luvit-meta/library", words = { "vim%.uv" } },
		},
	},
	dependencies = {
		{
			"Bilal2453/luvit-meta",
			lazy = true,
			enabled = true,
			commit = "ce76f6f6cdc9201523a5875a4471dcfe0186eb60",
		},
	},
}, pluginconf.lazydev or {})
