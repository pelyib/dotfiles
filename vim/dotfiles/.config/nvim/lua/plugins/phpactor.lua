return {
    'phpactor/phpactor',
    tag = "2023.09.24.0",
    build = function ()
        --[[
        TODO: add build script to run composer install in the installed plugin directory [botond.pelyi]
        cd into vim.fn.stdpath("data") .. '/lazy/phpactor'
        then run the composer install --no-dev --ignore-plaform-reqs
        --]]
    end,
}
