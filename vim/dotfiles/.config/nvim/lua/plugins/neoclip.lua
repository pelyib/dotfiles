local pluginconf = require("pelyib.pluginconf").config.patched

return vim.tbl_deep_extend("force", {
	"AckslD/nvim-neoclip.lua",
	enabled = false,
	commit = "4e406ae",
	dependencies = {
		{ "kkharji/sqlite.lua", module = "sqlite" },
	},
	opts = { enable_persistent_history = true, continuous_sync = true },
	config = function(_, opts)
		require("neoclip").setup(opts)
		require("telescope").load_extension("neoclip")
	end,
}, pluginconf.neoclip or {})
