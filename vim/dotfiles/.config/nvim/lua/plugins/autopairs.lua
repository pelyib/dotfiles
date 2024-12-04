local pluginconf = require('pelyib.pluginconf').config.patched

return vim.tbl_deep_extend(
    "force",
    {
        "jiangmiao/auto-pairs",
        enabled = false,
        tag = "v2.0.0"
    },
    pluginconf.autopairs or {}
)
