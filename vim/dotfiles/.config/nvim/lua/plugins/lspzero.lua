return {
    'VonHeikemen/lsp-zero.nvim',
    lazy = false,
    branch = 'v2.x',
    dependencies = {
        {'neovim/nvim-lspconfig'},
        {
		'williamboman/mason.nvim',
		lazy=false,
		build = function()
			pcall(vim.cmd, 'MasonUpdate')
		end 
	},
        {'williamboman/mason-lspconfig.nvim'},
        {
            'hrsh7th/nvim-cmp',
            dependencies = {
                { 'hrsh7th/cmp-buffer' }
            },
            config = function ()
                local cmp = require("cmp")
                cmp.setup({
                    sources = cmp.config.sources({
                        { name = 'nvim_lsp' }
                    }, {
                        { name = 'buffer' }
                    })
                })
            end
        },
        {'hrsh7th/cmp-nvim-lsp'},
        {'L3MON4D3/LuaSnip'}
    }
}
