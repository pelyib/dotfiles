local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend("force", {
	"akinsho/toggleterm.nvim",
	enabled = false,
	lazy = true,
	cmd = { "ToggleTerm", "TermExec" },
	version = "v2.5.0",
	opts = {
		direction = "float",
		--open_mapping = [[<F7>]],
		open_mapping = [[<leader>t]],
		auto_scroll = false,
	},
}, pluginconf.toggleterm or {})
