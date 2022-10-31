-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, zen_mode = pcall(require, "zen-mode")
if not status_ok then
  return
end

zen_mode.setup({})
