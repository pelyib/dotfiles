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
	keys = {
		{ "gc", mode = { "n", "v" }, desc = "Comment toggle" },
		{ "gb", mode = { "n", "v" }, desc = "Comment toggle blockwise" },
	},
	tag = "v0.8.0",
	config = function()
		local comment_ok, comment = pcall(require, "Comment")
		if comment_ok then
			comment.setup()
		end
	end,
}, pluginconf.comment)
