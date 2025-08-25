local hostConf_ok, hostConf = pcall(require, "pelyib.pluginconf-host")
if not hostConf_ok then
	hostConf = { config = {} }
end

local projectConf_ok, projectConf = pcall(require, "pelyib.pluginconf-project")
if not projectConf_ok then
	projectConf = { config = {} }
end

local M = {
	config = {
		patched = {},
		origin = {
			alpha = {
				enabled = false,
			},
			autopairs = {
				enabled = false,
			},
			barbecue = {
				enabled = false,
			},
			bracketpair = {
				enabled = false,
			},
			codeium = {
				enabled = false,
			},
			comment = {
				enabled = false,
			},
			copilot = {
				enabled = false,
			},
			dapui = {
				enabled = false,
			},
			dap = {
				enabled = false,
			},
			devicons = {
				enabled = false,
			},
			dressing = {
				enabled = false,
			},
			formatter = {
				enabled = false,
				-- Default formatter configuration
				format_on_save = false,
				format_on_save_filetypes = { "php", "javascript", "typescript", "lua", "python", "go" },
				keybinding = "<leader>f",
				-- Formatter tool configurations
				phpcsfixer = {
					cmd = "php-cs-fixer",
					args = { "fix", "%" },
				},
				prettier = {
					cmd = "prettier",
					args = { "--write", "%" },
				},
				stylua = {
					cmd = "stylua",
					args = { "%" },
				},
				black = {
					cmd = "black",
					args = { "%" },
				},
				gofmt = {
					cmd = "gofmt",
					args = { "-w", "%" },
				},
				-- Map filetypes to formatter tools
				filetype_formatters = {
					php = "phpcsfixer",
					javascript = "prettier",
					typescript = "prettier",
					javascriptreact = "prettier",
					typescriptreact = "prettier",
					json = "prettier",
					lua = "stylua",
					python = "black",
					go = "gofmt",
				},
			},
			gitblame = {
				enabled = false,
			},
			kanagawa = {
				enabled = false,
			},
			gruvbox = {
				enabled = false,
			},
			lineindicators = {
				enabled = false,
			},
			lazydev = {
				enabled = false,
			},
			lspzero = {
				enabled = false,
			},
			navbuddy = {
				enabled = false,
			},
			neoclip = {
				enabled = false,
			},
			neodev = {
				enabled = false,
			},
			neotree = {
				enabled = false,
			},
			neotest = {
				enabled = false,
			},
			neotest_jest = {
				enabled = false,
			},
			neotest_phpunit = {
				enabled = false,
				-- setup = {
				--     phpunit_cmd = function()
				--         return "/absolute/path/of/dotfiles/vim/vendor/neotest/phpic"
				--     end,
				-- }
			},
			neotest_pest = {
				enabled = false,
				-- setup = {
				--     sail_enabled = function () return false end,
				--     pest_cmd = "/absolute/path/of/dotfiles/vim/vendor/neotest/phpic",
				-- }
			},
			neotest_golang = {
				enabled = false,
			},
			noice = {
				enabled = false,
			},
			notify = {
				enabled = false,
			},
			phpactor = {
				enabled = false,
			},
			phpactornvim = {
				enabled = false,
			},
			phpcsfixer = {
				enabled = false,
			},
			statusline = {
				enabled = false,
			},
			telescope = {
				enabled = false,
			},
			toggleterm = {
				enabled = false,
			},
			treesitter = {
				enabled = false,
			},
			ufo = {
				enabled = false,
			},
		},
	},
	host = {
		origin = {},
	},
	project = {
		origin = {},
	},
}

M.setup = function()
	M.config.patched = vim.tbl_deep_extend("force", M.config.origin, hostConf.config, projectConf.config)
end

return M
