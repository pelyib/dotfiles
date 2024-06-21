local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    "force",
    {
        -- consider to switch to zbirenbaum/copilot.lua
        "github/copilot.vim",
        enabled = false,
        tag = "v1.35.0"
    },
    pelyib.config.copilot
)
