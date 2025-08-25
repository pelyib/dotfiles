local success, plugin = pcall(require, "nvim-navbuddy")
if success == false then
	return
end

vim.keymap.set("n", "ar", function()
	plugin.open()
end)
