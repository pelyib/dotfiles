local M = {
	config = {},
}

M.setup = function()
	local loaded, locConfig = pcall(require, "local/pluginconfig")

	if loaded then
		M.config = locConfig
	end
end

return M
