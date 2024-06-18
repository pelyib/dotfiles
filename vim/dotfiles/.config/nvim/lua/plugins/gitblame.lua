return {
    'f-person/git-blame.nvim',
    enabled = true,
    commit = "f07e913",
    config = function ()
        require("gitblame").setup({
            enabled = false,
        })
    end
}
