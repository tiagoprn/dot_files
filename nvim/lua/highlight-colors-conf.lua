-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, nvim_highlight_colors = pcall(require, "nvim-highlight-colors")
if not status_ok then
	return
end

nvim_highlight_colors.setup({
	render = "background", -- 'first_column', 'foreground' or 'background'
	enable_tailwind = true,
})
