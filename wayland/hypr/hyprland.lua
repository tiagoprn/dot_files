-- Main Hyprland Lua configuration
-- See https://wiki.hypr.land/Configuring/Start/

require("autostart")
require("binds")
require("window-rules")

------------------
---- MONITORS ----
------------------

-- internal monitor (laptop)
hl.monitor({
  output = "eDP-1",
  mode = "preferred",
  position = "auto",
  scale = 0.8,
})

-- external ultrawide monitor (LG 25UM58G, 2560x1080@60)
hl.monitor({
  output = "desc:LG Electronics 25UM58G 0x01010101",
  mode = "2560x1080@60",
  position = "auto",
  scale = 0.8,
})

-- external portable 4K monitor (RTD TH-133UCJ) -- disabled, replaced by LG 25UM58G
-- hl.monitor({
--   output = "desc:RTD TH-133UCJ 0x01010101",
--   mode = "preferred",
--   position = "auto",
--   scale = 1.5,
-- })

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")

---------------
---- DEBUG ----
---------------

-- Keep the log stream alive. gdm-wayland-session forwards stdout to journald
-- with timestamps, and the hyprutils logger flushes after every line, so a
-- compositor killed mid-run still leaves its last lines in the journal.
-- In 0.57.x the logger gate is: stdout_enable = !disable_logs &&
-- enable_stdout_logs, so disable_logs must stay false for this to work.
-- disable_time=false adds timestamps to the file log itself.
-- Cost: the journal grows faster (DEBUG lines flow continuously).
hl.config({
  debug = {
    disable_logs = false,
    disable_time = false,
    enable_stdout_logs = true,
  },
})

---------------
---- INPUT ----
---------------

hl.config({
  input = {
    kb_layout = "corne-cedilla",
    kb_variant = "intl",
    kb_model = "",
    kb_options = "lv3:ralt_switch",
    kb_rules = "",

    follow_mouse = 2,

    touchpad = {
      natural_scroll = false,
    },

    sensitivity = 0,
  },

  misc = {
    -- 0 disables workspace tokens (apps open on the active workspace).
    -- Mode 2 pinned apps spawned by the long-lived vicinae server to workspace 1.
    initial_workspace_tracking = 0,
  },
})

---------------------
---- LOOK AND FEEL ----
---------------------

hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 5,

    border_size = 3,

    col = {
      active_border = { colors = { "rgba(1f4529aa)", "rgba(6ec207aa)" }, angle = -5 },
      inactive_border = "rgba(595959aa)",
    },

    layout = "master",
  },

  decoration = {
    rounding = 5,
  },
})

------------------
---- ANIMATIONS ----
------------------

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

-------------------------------
---- MASTER LAYOUT CONFIG ----
-------------------------------

hl.config({
  master = {
    orientation = "right",
    mfact = 0.50,
    new_status = "master",
  },
})
