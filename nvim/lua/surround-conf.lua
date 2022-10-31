-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, surround = pcall(require, "nvim-surround")
if not status_ok then
	return
end

surround.setup({})
