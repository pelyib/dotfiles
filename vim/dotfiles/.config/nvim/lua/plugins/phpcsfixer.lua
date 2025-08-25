local pluginconf = require("pelyib.pluginconf").config.patched

return vim.tbl_deep_extend("force", {
	"stephpy/vim-php-cs-fixer",
	enabled = false,
	commit = "d6dec5d",
}, pluginconf.phpcsfixer or {})
