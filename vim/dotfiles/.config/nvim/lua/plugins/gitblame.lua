local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend("force", {
	"f-person/git-blame.nvim",
	enabled = false,
	lazy = true,
	cmd = { "GitBlameToggle", "GitBlameCopyCommitURL", "GitBlameCopyFileURL" },
	commit = "f07e913",
	config = function()
		local gitblame_ok, gitblame = pcall(require, "gitblame")
		if gitblame_ok then
			gitblame.setup({
				enabled = false,
			})
		end
	end,
}, pluginconf.gitblame or {})
