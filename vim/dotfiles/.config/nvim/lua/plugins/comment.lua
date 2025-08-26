local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend("force", {
	"numToStr/Comment.nvim",
	enabled = false,
	lazy = true,
	config = true,
	keys = {
		{ "gc", mode = { "n", "v" }, desc = "Comment toggle" },
		{ "gb", mode = { "n", "v" }, desc = "Comment toggle blockwise" },
	},
	tag = "v0.8.0",
}, pluginconf.comment)
