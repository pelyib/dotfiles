vim.keymap.set("n", "zo", "<cmd>foldopen<cr>")
vim.keymap.set("n", "zc", "<cmd>foldclose<cr>")

local success, ufo = pcall(require, "ufo")
if success == false then
	return
end

vim.keymap.set("n", "zR", ufo.openAllFolds)
vim.keymap.set("n", "zM", ufo.closeAllFolds)
