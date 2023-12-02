return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function ()
        require("telescope").setup({
            defaults = {
                path_display = {
                    "shorten",
                    shorten = {
                        len = 3,
                        exclude = {2, -1, -2}
                    }
                },
                layout_strategy = "vertical",
                layout_config = {
                    horizontal = {
                        -- prompt_position = "top"
                    }
                },
                preview = {
                    treesitter = true,
                },
            },
            pickers = {
                find_files = {
                    hidden = true,
                    --theme = 'dropdown'
                },
                live_grep = {
                    hidden = true,
                    show_line = false,
                    --theme = 'dropdown'
                },
                lsp_references = {
                    --theme = 'dropdown'
                },
            }
        })
    end
}
