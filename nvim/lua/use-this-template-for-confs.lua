-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, plugin_name = pcall(require, "plugin-name")
if not status_ok then
	return
end

plugin_name.setup({})
