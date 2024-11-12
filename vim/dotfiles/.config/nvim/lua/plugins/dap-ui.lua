local pluginconf = require('pelyib.pluginconf').config.patched

return vim.tbl_deep_extend(
    "force",
    {
        "rcarriga/nvim-dap-ui",
        enabled = false,
        tag = "v3.9.1",
        requires = {
            "mfussenegger/nvim-dap"
        },
        config = function ()
            require("dapui").setup()
        end
    },
    pluginconf.dapui or {}
)
