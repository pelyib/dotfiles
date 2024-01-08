-- https://github.com/rcarriga/nvim-notify/issues/50#issuecomment-1014595230

---@param clientCallback function
return function (command, clientCallback)
    local stdin = vim.loop.new_pipe()
    local stdout = vim.loop.new_pipe()
    local stderr = vim.loop.new_pipe()
    local output = ""
    local error_output = ""

    local callback = function (code, _)
        stdin:close()
        stdout:close()
        stderr:close()
        local result, _ = pcall(function () clientCallback(code, output, error_output) end)
        if not result then
            vim.notify("Callback script is not callable or failed", vim.log.levels.WARN, {"Shell script runner"})
        end
    end

    --@TODO: find the first single word instead of the first item [botond.pelyi]
    -- example: env=test make test
    vim.loop.spawn(command[1], {
        stdio = { stdin, stdout, stderr },
        detached = true,
        args = #command > 1 and vim.list_slice(command, 2, #command) or nil,
    }, callback)

    stdout:read_start(function(err, data)
        if err then
            error_output = error_output .. (err or data)
            return
        end
        if data then
            output = output .. data
        end
    end)
    stderr:read_start(function(err, data)
        if err or data then
            error_output = error_output .. (err or data)
        end
    end)
end
