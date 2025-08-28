local success, lsp = pcall(require, "lsp-zero")
if success == false then
	return
end

lsp.on_attach(function(_, bufnr)
	lsp.default_keymaps({ buffer = bufnr })

	local builtin_ok, builtin = pcall(require, "telescope.builtin")
	if not builtin_ok then
		return
	end

	vim.keymap.set("n", "gr", function()
		builtin.lsp_references({ include_current_line = true })
	end, { buffer = true })
	vim.keymap.set("n", "gd", function()
		builtin.lsp_definitions()
	end, { buffer = true })
	-- Don't know why but lsp-zero does not register this
	vim.keymap.set("n", "gi", function()
		builtin.lsp_implementations()
	end, { buffer = true })
end)
