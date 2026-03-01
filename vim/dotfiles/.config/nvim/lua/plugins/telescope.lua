local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend("force", {
	"nvim-telescope/telescope.nvim",
	enabled = true,
	lazy = true,
	cmd = { "Telescope" },
	tag = "0.1.4",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-live-grep-args.nvim",
			version = "^1.0.0",
		},
	},
	config = function()
		local telescope_ok, telescope = pcall(require, "telescope")
		if not telescope_ok then
			return
		end
		telescope.setup({
			defaults = {
				prompt_prefix = " 🔍 ",
				path_display = {
					"shorten",
					shorten = {
						len = 3,
						exclude = { 2, -1, -2 },
					},
				},
				layout_strategy = "vertical",
				layout_config = {
					horizontal = {
						-- prompt_position = "top"
					},
				},
				preview = {
					treesitter = false,
					filesize_limit = 1,
				},
				file_ignore_patterns = { ".git/" },
			},
			pickers = {
				find_files = {
					hidden = true,
					--theme = 'dropdown'
				},
				live_grep = {
					hidden = true,
					show_line = false,
					--theme = 'dropdown'
				},
				lsp_references = {
					show_line = false,
					--theme = 'dropdown'
				},
				buffers = {
					mappings = {
						i = {
							["<c-D>"] = "delete_buffer",
						},
					},
				},
			},
		})

		local live_grep_ok, _ = pcall(telescope.load_extension, "live_grep_args")
		if not live_grep_ok then
			vim.notify("Failed to load telescope live_grep_args extension", vim.log.levels.WARN)
		end

		local noice_ok, _ = pcall(telescope.load_extension, "noice")
		if not noice_ok then
			vim.notify("Failed to load telescope noice extension", vim.log.levels.WARN)
		end
	end,
}, pluginconf.telescope or {})
