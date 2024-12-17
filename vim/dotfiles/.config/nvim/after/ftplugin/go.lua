vim.keymap.set('n', 'csf', function ()
    require("pelyib.shell-runner")({
        "gofmt",
        "-l",
        "-w",
        vim.fn.getcwd()
    }, function ()
        vim.notify("CS fixed")
    end)
end)
