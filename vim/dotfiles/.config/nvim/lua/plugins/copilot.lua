local pluginconf = require('pelyib.pluginconf').config.patched

return vim.tbl_deep_extend(
    "force",
    {
        -- consider to switch to zbirenbaum/copilot.lua
        "github/copilot.vim",
        enabled = false,
        tag = "v1.35.0"
    },
    pluginconf.copilot or {}
)
