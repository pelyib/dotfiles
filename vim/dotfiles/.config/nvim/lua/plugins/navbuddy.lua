local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend("force", {
	"SmiteshP/nvim-navbuddy",
	commit = "f22bac988f2dd073601d75ba39ea5636ab6e38cb",
	enabled = false,
	lazy = true,
	cmd = { "Navbuddy" },
	dependencies = {
		{
			"SmiteshP/nvim-navic",
			commit = "8649f694d3e76ee10c19255dece6411c29206a54",
		},
		"MunifTanjim/nui.nvim",
	},
	config = function()
		local navbuddy_ok, navbuddy = pcall(require, "nvim-navbuddy")
		if not navbuddy_ok then
			return
		end
		local navbuddy_actions_ok, navbuddy_actions = pcall(require, "nvim-navbuddy.actions")
		if not navbuddy_actions_ok then
			return
		end
		navbuddy.setup({
			window = {
				border = "rounded",
				size = {
					width = "80%",
					height = "30%",
				},
				sections = {
					left = {
						size = "25%",
					},
					mid = {
						size = "50%",
					},
					right = {
						preview = "never",
					},
				},
			},
			mappings = {
				["t"] = navbuddy_actions.telescope({
					layout_config = {
						height = 0.60,
					},
					layout_strategy = "vertical",
				}),
			},
			lsp = { auto_attach = true },
		})
	end,
}, pluginconf.navbuddy or {})
