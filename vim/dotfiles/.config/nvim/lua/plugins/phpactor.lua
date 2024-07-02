local pelyib = vim.g.pelyib.pluginconfig

return vim.tbl_deep_extend(
    "force",
    {
        'phpactor/phpactor',
        enabled = false,
        tag = "2023.09.24.0",
        build = function ()
            print("Building phpactor")
            local composerHome = os.getenv("COMPOSER_HOME") or os.getenv("HOME") .. "/.composer"
            require("pelyib.shell-runner")(
                {
                    "docker", "run" , "--rm", "--interactive",
                        "--env", "COMPOSER_HOME",
                        "--volume", composerHome .. ":" .. composerHome,
                        "--volume", vim.fn.stdpath("data") .. "/lazy/phpactor:/app",
                        "composer:2.7.7", "composer", "install", "--no-dev", "--ignore-platform-reqs", "--no-interaction", "--no-progress", "--no-suggest", "--prefer-dist", "--optimize-autoloader"
                },
                function (code, success, error)
                    if code == 0 then
                        print("Composer install successful")
                    else
                        print("Composer install failed")
                        print(error)
                    end
                end
            )
        end,
        dependencies = {
            vim.tbl_deep_extend(
            "force",
            {
                "gbprod/phpactor.nvim",
                enabled = false,
                tag = "v1.0.1",
                config = function()
                    require("phpactor").setup({
                        install = {
                            path = vim.fn.stdpath("data") .. "/lazy/phpactor",
                            branch = "2023.09.24.0",
                            bin = vim.fn.stdpath("data") .. "/lazy/phpactor/bin/phpactor",
                            php_bin = "php",
                            composer_bin = "composer2",
                            git_bin = "git",
                            check_on_startup = "none",
                        },
                        lspconfig = {
                            enabled = false,
                            options = {},
                        },
                    })
                end
            },
            pelyib.config.phpactor
            )
        },
    },
    pelyib.config.phpactor
)
