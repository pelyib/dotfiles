return {
    'f-person/git-blame.nvim',
    commit = "f07e913",
    config = function ()
        require("gitblame").setup({
            enabled = false,
        })
    end
}
