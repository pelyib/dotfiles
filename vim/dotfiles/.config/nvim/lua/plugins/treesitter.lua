local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend("force", {
	"nvim-treesitter/nvim-treesitter",
	enabled = false,
	lazy = true,
	event = { "BufReadPost", "BufNewFile" },
	-- Swtich to a specific tag later when they release a new version that contains the tree-sitter-php v0.22.5
	-- that fixes this issue: https://github.com/tree-sitter/tree-sitter-php/issues/243
	--tag = 'v0.9.2',
	commit = "caf275382f91ec8a2498d455c4d7d3fd0265ebd3",
	build = ":TSUpdate",
	config = function()
		vim.cmd([[syntax off]])
		local treesitter_ok, treesitter = pcall(require, "nvim-treesitter.configs")
		if not treesitter_ok then
			return
		end
		treesitter.setup({
			ensure_installed = {
				"bash",
				"cmake",
				"css",
				"dockerfile",
				"dot",
				"go",
				"graphql",
				"html",
				"hcl",
				"javascript",
				"json",
				"lua",
				"luadoc",
				"make",
				"markdown",
				"php",
				"python",
				"regex",
				"sql",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = {
				enable = true,
			},
		})
		vim.treesitter.language.register("typescript", "typescriptreact")
		vim.treesitter.language.register("hcl", "terraform")
	end,
}, pluginconf.treesitter or {})
