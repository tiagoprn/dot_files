-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, buffer_manager = pcall(require, "buffer_manager")
if not status_ok then
	return
end

buffer_manager.setup({
	line_keys = "1234567890",
	select_menu_item_commands = {
		edit = {
			key = "<CR>",
			command = "edit",
		},
		v = {
			key = "<C-v>",
			command = "vsplit",
		},
		s = {
			key = "<C-x>",
			command = "split",
		},
		t = {
			key = "<C-t>",
			command = "tabnew",
		},
	},
})
