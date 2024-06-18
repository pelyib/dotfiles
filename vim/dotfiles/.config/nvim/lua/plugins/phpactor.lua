return {
    'phpactor/phpactor',
    enabled = true,
    tag = "2023.09.24.0",
    build = function ()
        --[[
        TODO: add build script to run composer install in the installed plugin directory [botond.pelyi]
        cd into vim.fn.stdpath("data") .. '/lazy/phpactor'
        then run the composer install --no-dev --ignore-plaform-reqs
        -d, --working-dir=WORKING-DIR                        If specified, use the given directory as working directory.
        --]]
    end,
}
