local wezterm = require 'wezterm';
--
-- Function to handle and log errors
local function log_error(err)
  -- Open the log file in append mode. Specify the full path if necessary.
  local file = io.open(os.getenv("HOME") .. "/wezterm_error.log", "a")
  if file then
    file:write(os.date("%Y-%m-%d %H:%M:%S") .. " - Error: " .. tostring(err) .. "\n")
    file:close()
  end
end

-- Main configuration with error handling
local status, err = pcall(function()
  -- Your normal configuration settings go here
  -- Example of setting up a startup notification
  wezterm.on("gui-startup", function()
    wezterm.run_child_process({"notify-send", "Terminal started"})
  end)

  -- More configuration can follow
end)

-- Check if there was an error in the main configuration
if not status then
  log_error(err)
end

return {
  enable_tab_bar = false,
  window_background_opacity = 0.9,
}
