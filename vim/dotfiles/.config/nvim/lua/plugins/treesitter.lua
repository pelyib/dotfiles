local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

-- Since treesitter is a builtin feature of Neovim nvim-treesitter purpose has been changed to be a helper for
-- installing parsers and providing some extra features like folding and indenting. So we can disable it by default and
-- only enable it when we need it, which is when we open a filetype that has a treesitter parser available.
return vim.tbl_deep_extend("force", {
	"nvim-treesitter/nvim-treesitter",
	enabled = false,
	lazy = false,
	-- Swtich to a specific tag later when they release a new version that contains the tree-sitter-php v0.22.5
	-- that fixes this issue: https://github.com/tree-sitter/tree-sitter-php/issues/243
	--tag = 'v0.9.2',
	commit = "dc42c209f3820bdfaae0956f15de29689aa6b451",
	build = ":TSUpdate",
	config = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			callback = function(event)
				-- make sure nvim-treesitter is loaded
				local ok, nvim_treesitter = pcall(require, "nvim-treesitter")

				-- no nvim-treesitter, maybe fresh install
				if not ok then
					return
				end

				local parsers = require("nvim-treesitter.parsers")

				if not parsers[event.match] or not nvim_treesitter.install then
					return
				end

				local ft = vim.bo[event.buf].ft
				local lang = vim.treesitter.language.get_lang(ft)
				nvim_treesitter.install({ lang }):await(function(err)
					if err then
						vim.notify("Treesitter install error for ft: " .. ft .. " err: " .. err)
						return
					end

					pcall(vim.treesitter.start, event.buf)
					-- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				end)
			end,
		})

		require("nvim-treesitter").install({
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
		})

		vim.treesitter.language.register("typescript", "typescriptreact")
		vim.treesitter.language.register("hcl", "terraform")
	end,
}, pluginconf.treesitter or {})
