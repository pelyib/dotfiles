# Test GO app

## DAP configuration

Install [Go lang](https://go.dev/), [delve](https://github.com/go-delve/delve), [go-debug-adapter](https://github.com/golang/vscode-go) (with Mason)

`--no-deprecation` is required to suppress deprecation warnings from Node.js because of the usage of `new Buffer` in the
go-debug-adapter.
Fix the `dlvToolPath` to point to your `dlv` executable.

```lua
projectConf = {
	config = {
		dap = {
			opts = {
				clients = {
					go = {
						adapter = {
							type = "executable",
							command = "node",
							args = {
								"--no-deprecation",
								os.getenv("HOME")
									.. "/.local/share/nvim/mason/packages/go-debug-adapter/extension/dist/debugAdapter.js",
							},
						},
						configurations = {
							{
								name = "Go debugger",
								type = "go",
								request = "launch",
								mode = "debug",
								program = "${file}",
								dlvToolPath = vim.fn.exepath("/path/of/dlv"),
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
