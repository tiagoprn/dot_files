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
  scale = 1,
})

-- external portable 4K monitor
hl.monitor({
  output = "desc:RTD TH-133UCJ 0x01010101",
  mode = "preferred",
  position = "auto",
  scale = 1.5,
})

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")

---------------
---- INPUT ----
---------------

hl.config({
  input = {
    kb_layout = "us",
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
    initial_workspace_tracking = 2,
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
    mfact = 0.60,
    new_status = "master",
  },
})
