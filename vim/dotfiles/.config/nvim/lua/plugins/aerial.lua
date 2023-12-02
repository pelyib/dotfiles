return {
    "stevearc/aerial.nvim",
    commit = "8876456",
    config = function ()
        require('aerial').setup({
            close_automatic_events = {'unfocus'},
            layout={
                default_direction = 'float'
            },
            float={
                relative='win'
            }
        })
        vim.keymap.set('n', 'ar', ':AerialToggle<CR>')
    end
}
