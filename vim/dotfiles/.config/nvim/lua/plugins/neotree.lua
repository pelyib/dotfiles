local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend("force", {
	"nvim-neo-tree/neo-tree.nvim",
	enabled = true,
	lazy = true,
	cmd = { "NeoTreeFloatToggle", "NeoTreeShow", "NeoTreeFocus" },
	keys = {
		{ "fb", "<cmd>NeoTreeFloatToggle<cr>", desc = "Toggle NeoTree" },
	},
	branch = "v2.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			commit = "cff25ce621e6d15fae0b0bfe38c00be50ce38468",
		},
		{
			"MunifTanjim/nui.nvim",
			commit = "35da9ca1de0fc4dda96c2e214d93d363c145f418",
		},
	},
	opts = {
		window = {
			position = "float",
		},
		filesystem = {
			filtered_items = {
				hide_dotfiles = false,
				hide_gitignored = false,
				never_show = {
					".DS_Store",
					"thumbs.db",
					".git",
				},
			},
		},
	},
}, pluginconf.neotree or {})
