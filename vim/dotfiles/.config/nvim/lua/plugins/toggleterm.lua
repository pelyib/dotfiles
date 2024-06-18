return {
    'akinsho/toggleterm.nvim',
    enabled = true,
    version = "v2.5.0",
    config = function ()
        require('toggleterm').setup({
            direction = 'float',
            --open_mapping = [[<F7>]],
            open_mapping = [[<leader>t]],
            auto_scroll = false
        })
    end
}
