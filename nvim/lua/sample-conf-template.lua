-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, cool_plugin = pcall(require, "cool-plugin")
if not status_ok then
	return
end

cool_plugin.setup({})
