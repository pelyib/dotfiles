-- Import formatter types for better code completion
require("formatter.types")

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
			filetype_detection = {
				enabled = false,
			},
			formatter = {
				enabled = false,
				---@type FormatterPluginConfig
				opts = {
					-- Core formatter settings
					keybinding = "<leader>f",

					-- External formatter configurations
					formatters = {
						phpcsfixer = {
							command = { "php-cs-fixer", "fix", "%" },
							success_message = "PHP CS Fixer: Formatting complete",
							filetypes = { "php" },
							format_on_save = false,
						},
						prettier = {
							command = { "prettier", "--write", "%" },
							success_message = "Prettier: Formatting complete",
							filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json" },
							format_on_save = false,
						},
						stylua = {
							command = { "stylua", "%" },
							success_message = "Stylua: Formatting complete",
							filetypes = { "lua" },
							format_on_save = false,
						},
						black = {
							command = { "black", "%" },
							success_message = "Black: Formatting complete",
							filetypes = { "python" },
							format_on_save = false,
						},
						gofmt = {
							command = { "gofmt", "-w", "%" },
							success_message = "Gofmt: Formatting complete",
							filetypes = { "go" },
							format_on_save = false,
						},

						-- Example of complex command with environment variables
						-- phpstan = {
						-- 	command = { "env", "XDEBUG_MODE=off", "php", "vendor/bin/phpstan", "analyse", "%" },
						-- 	post_action = "none",  -- Don't reload buffer for analysis tools
						-- 	success_message = "PHPStan: Analysis complete",
						-- 	filetypes = { "php" }
						-- },
					},
				},
			},
			gitblame = {
				enabled = false,
			},
			gruvbox = {
				enabled = false,
			},
			kanagawa = {
				enabled = false,
			},
			lazydev = {
				enabled = false,
			},
			lineindicators = {
				enabled = false,
			},
			lspzero = {
				enabled = false,
			},
			markview = {
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
			neotree = {
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
			php_test_runner = {
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
