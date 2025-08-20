local pluginconf_ok, pluginconf = pcall(require, 'pelyib.pluginconf')
if not pluginconf_ok then
    pluginconf = { config = { patched = {} } }
else
    pluginconf = pluginconf.config.patched
end

return vim.tbl_deep_extend(
    "force",
    {
        -- consider to switch to zbirenbaum/copilot.lua
        "github/copilot.vim",
        enabled = false,
        lazy = true,
        event = "InsertEnter",
        tag = "v1.35.0"
    },
    pluginconf.copilot or {}
)
