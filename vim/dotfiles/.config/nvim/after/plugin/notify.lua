local success, notify = pcall(require, "notify")
if success == false then
	return
end

local success, telescope = pcall(require, "telescope")
if success == false then
	return
end

telescope.load_extension("notify")
