-- https://github.com/rcarriga/nvim-notify/issues/50#issuecomment-1014595230

return function (command)
    local stdin = vim.loop.new_pipe()
    local stdout = vim.loop.new_pipe()
    local stderr = vim.loop.new_pipe()
    local output = ""
    local error_output = ""
    local notify = function (msg, level)
        vim.notify(msg, level, { title = table.concat(command, " ") })
    end
    vim.loop.spawn(command[1], {
        stdio = { stdin, stdout, stderr },
        detached = true,
        args = #command > 1 and vim.list_slice(command, 2, #command) or nil,
    }, function(code, _)
        stdin:close()
        stdout:close()
        stderr:close()
        if #output > 0 then
            notify(output)
        end
        if #error_output > 0 then
            notify(error_output, "error")
        end
        if #output == 0 and #error_output == 0 then
            notify("No output of command, exit code: "..code, "warn")
        end
    end)
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
