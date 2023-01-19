-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, luapad = pcall(require, "luapad")
if not status_ok then
	return
end

luapad.setup({
	count_limit = 150000,
	error_indicator = true,
	eval_on_change = true,
	eval_on_move = false,
	error_highlight = "WarningMsg",
	split_orientation = "horizontal",
	on_init = function()
		print("Hello from Luapad!")
	end,
	context = {
		-- I can put variables and functions here, so that they will be available as globals to luapad
		the_answer = 42, -- variable
		shout = function(str) -- function
			return (string.upper(str) .. "!")
		end,
	},
})
