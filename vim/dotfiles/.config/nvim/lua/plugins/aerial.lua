return {
    "stevearc/aerial.nvim",
    commit = "8876456",
    enabled = true,
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
    end
}
