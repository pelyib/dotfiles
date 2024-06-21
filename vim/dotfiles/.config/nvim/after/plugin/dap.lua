local success, dap = pcall(require, "dap")
if success == false then
    return
end

dap.adapters.php = {
    type = 'executable',
    command = 'node',
-- Mason installed version is failing, i must install manually and set the path
-- TODO: fix it or add installer script [botond.pelyi]
--    args = { vim.fn.exepath('php-debug-adapter') }
    args = { "/TODO/Add/valid/path/phpDebug.js", }
}
dap.configurations.php = {
    {
        type = 'php',
        request = 'launch',
        name = 'Listen for Xdebug',
        port = 9003,
        pathMappings = {
            -- TODO: Dynamic configuration [botond.pelyi]
            ["/var/www/html/"] = "${workspaceFolder}/vim/test-files/php/",
        }
    }
}
