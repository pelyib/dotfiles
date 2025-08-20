local pluginconf_ok, pluginconf = pcall(require, 'pelyib.pluginconf')
if not pluginconf_ok then
    pluginconf = { config = { patched = {} } }
else
    pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend(
    "force",
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        enabled = false,
        lazy = true,
        event = { "BufReadPost", "BufNewFile" },
        tag = "v1.2.0",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        opts = {
            -- configurations go here
        },
    },
    pluginconf.barbecue or {}
)
