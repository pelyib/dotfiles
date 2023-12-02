return {
    'goolord/alpha-nvim',
    commit = "29074ee",
    requires = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        require'alpha'.setup(require'alpha.themes.startify'.config)
    end
}
