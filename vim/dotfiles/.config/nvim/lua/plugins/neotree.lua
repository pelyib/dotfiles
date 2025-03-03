local pluginconf = require("pelyib.pluginconf").config.patched

return vim.tbl_deep_extend(
    "force",
    {
        "nvim-neo-tree/neo-tree.nvim",
        enabled = true,
        lazy = false,
        branch = "v2.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
                commit = "cff25ce621e6d15fae0b0bfe38c00be50ce38468",
            },
            {
                "MunifTanjim/nui.nvim",
                commit = "35da9ca1de0fc4dda96c2e214d93d363c145f418",
            }
        },
        config = function ()
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
    },
    pluginconf.neotree or {}
)
