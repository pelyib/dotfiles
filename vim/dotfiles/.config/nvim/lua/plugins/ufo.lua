local pluginconf_ok, pluginconf = pcall(require, "pelyib.pluginconf")
if not pluginconf_ok then
	pluginconf = { config = { patched = {} } }
else
	pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend("force", {
	"kevinhwang91/nvim-ufo",
	enabled = false,
	tag = "v1.4.0",
	lazy = true,
	event = "BufReadPost",
	dependencies = {
		"kevinhwang91/promise-async",
	},
	config = function()
		vim.o.foldcolumn = "1"
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}
		local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
		if not lspconfig_ok then
			return
		end
		local language_servers = lspconfig.util.available_servers()
		for _, ls in ipairs(language_servers) do
			lspconfig[ls].setup({
				capabilities = capabilities,
			})
		end

		local ufo_ok, ufo = pcall(require, "ufo")
		if ufo_ok then
			ufo.setup()
		end
	end,
	keys = {
		{ "zo", mode = "n", "<cmd>foldopen<cr>", desc = "Open fold" },
		{ "zc", mode = "n", "<cmd>foldclose<cr>", desc = "Close fold" },
		{ "zO", mode = "n", function () require("ufo").openAllFolds() end, desc = "Open all folds" },
		{ "zC", mode = "n", function () require("ufo").closeAllFolds() end, desc = "Close all folds" },
	},
}, pluginconf.ufo or {})
