# Test PHP application

## DAP configuration

```lua
projectConf = {
	config = {
		dap = {
			opts = {
				clients = {
					php = {
						adapter = {
							type = "executable",
							command = "node",
							args = {
								os.getenv("HOME")
									.. "/.local/share/nvim/mason/packages/php-debug-adapter/extension/out/phpDebug.js",
							},
						},
						configurations = {
							{
								type = "php",
								request = "launch",
								name = "Listen for Xdebug",
								port = 9003,
								pathMappings = {
									["/var/www/html/"] = "${workspaceFolder}",
								},
							},
						},
					},
				},
			},
		},
	},
}

return projectConf
```
