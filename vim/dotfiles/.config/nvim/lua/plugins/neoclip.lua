return {
    'AckslD/nvim-neoclip.lua',
    commit = "4e406ae",
    dependencies = {
        {'kkharji/sqlite.lua', module = 'sqlite'},
    },
    config = function()
        require('neoclip').setup({enable_persistent_history = true, continuous_sync = true })
        require('telescope').load_extension('neoclip')
    end,
}
