local M = {
	config = {},
}

M.setup = function()
	local cwd = vim.fn.getcwd()
	local projectModule = cwd .. "/.local.lua"
	if vim.fn.filereadable(vim.fn.expand(projectModule)) == 1 then
		local ok, projectConf = pcall(dofile, projectModule)
		if ok and projectConf and projectConf.config then
			M.config = projectConf.config
		elseif not ok then
			vim.notify("Failed to load project config: " .. tostring(err), vim.log.levels.WARN)
		end
	end
end

return M
