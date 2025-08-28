local M = {}

-- Enhanced filetype detection that handles suffixes like .dist, .example, etc.
---@param filename string? Optional filename to analyze (uses current buffer if nil)
---@return string? effective_filetype The detected filetype, nil if no match
local function detect_filetype_from_filename(filename)
	filename = filename or vim.fn.expand("%:t")

	-- Handle common suffix patterns
	local base_name = filename
	local common_suffixes =
		{ "%.dist$", "%.example$", "%.template$", "%.sample$", "%.local$", "%.dev$", "%.prod$", "%.bak$" }

	-- Remove common suffixes to get the base filename
	for _, suffix in ipairs(common_suffixes) do
		base_name = base_name:gsub(suffix, "")
	end

	-- Try to detect filetype from base filename extension
	local extension = base_name:match("%.([^%.]+)$")
	if extension then
		local extension_to_filetype = {
			lua = "lua",
			js = "javascript",
			mjs = "javascript",
			ts = "typescript",
			jsx = "javascriptreact",
			tsx = "typescriptreact",
			php = "php",
			py = "python",
			go = "go",
			json = "json",
			yaml = "yaml",
			yml = "yaml",
			toml = "toml",
			xml = "xml",
			html = "html",
			htm = "html",
			css = "css",
			scss = "scss",
			sass = "sass",
			less = "less",
			md = "markdown",
			markdown = "markdown",
			sh = "sh",
			bash = "bash",
			zsh = "zsh",
			fish = "fish",
			vim = "vim",
			sql = "sql",
			rb = "ruby",
			rs = "rust",
			java = "java",
			c = "c",
			cpp = "cpp",
			cc = "cpp",
			cxx = "cpp",
			h = "c",
			hpp = "cpp",
			cs = "cs",
			kt = "kotlin",
			swift = "swift",
			dart = "dart",
		}

		return extension_to_filetype[extension]
	end

	-- Try to detect from full base filename (for files like Dockerfile, Makefile, etc.)
	local basename_to_filetype = {
		Dockerfile = "dockerfile",
		Makefile = "make",
		makefile = "make",
		Rakefile = "ruby",
		Gemfile = "ruby",
		Vagrantfile = "ruby",
		["docker-compose.yml"] = "yaml",
		["docker-compose.yaml"] = "yaml",
	}

	return basename_to_filetype[base_name]
end

-- Check and set the correct filetype for current buffer
function M.detect_and_set_filetype()
	local current_filetype = vim.bo.filetype
	local filename = vim.fn.expand("%:t")

	-- Only proceed if filetype is empty/generic or we have a suffix
	local has_suffix = filename:match("%.dist$")
		or filename:match("%.example$")
		or filename:match("%.template$")
		or filename:match("%.sample$")
		or filename:match("%.local$")
		or filename:match("%.dev$")
		or filename:match("%.prod$")
		or filename:match("%.bak$")

	if current_filetype == "" or current_filetype == "text" or has_suffix then
		local detected_filetype = detect_filetype_from_filename(filename)

		if detected_filetype and detected_filetype ~= current_filetype then
			vim.cmd("setfiletype " .. detected_filetype)
			vim.notify(
				"Filetype set to: " .. detected_filetype .. " (detected from: " .. filename .. ")",
				vim.log.levels.INFO
			)
		end
	end
end

-- Setup autocommand to detect filetypes on buffer open
function M.setup()
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = vim.api.nvim_create_augroup("EnhancedFiletypeDetection", { clear = true }),
		callback = function()
			-- Small delay to let Vim's built-in detection run first
			vim.defer_fn(function()
				M.detect_and_set_filetype()
			end, 10)
		end,
		desc = "Enhanced filetype detection for files with suffixes",
	})

	-- Create command for manual filetype detection
	vim.api.nvim_create_user_command("DetectFiletype", function()
		M.detect_and_set_filetype()
	end, { desc = "Manually detect and set filetype" })
end

return M
