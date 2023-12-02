return {
    "nvim-neo-tree/neo-tree.nvim",
    lazy=false,
    branch = "v2.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    config = function ()
        -- disable netrw at the very start of your init.lua (strongly advised)
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- set termguicolors to enable highlight groups
        vim.opt.termguicolors = true
        require("neo-tree").setup({
            window = {
                position = "float"
            },
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    never_show = {
                        ".DS_Store",
                        "thumbs.db",
                        ".git"
                    }
                }
            }
        })
        vim.keymap.set('n', 'fb', ':NeoTreeFloatToggle<CR>')
    end
}
