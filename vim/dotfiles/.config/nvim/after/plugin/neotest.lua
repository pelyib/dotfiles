local success, neotest = pcall(require, "neotest")
if success == false then
    return
end

vim.keymap.set("n", "rc", function ()
    neotest.run.run()
end)
vim.keymap.set("n", "rf", function ()
    neotest.run.run(vim.fn.expand("%"))
end)
