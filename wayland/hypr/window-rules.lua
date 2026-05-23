-- Window rules, layer rules, and workspace rules
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

----------------------------
---- WORKSPACE RULES ----
----------------------------

-- Workspace to monitor assignments
hl.workspace_rule({ workspace = "1", monitor = "eDP-1", default = true })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "5", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "7", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "9", monitor = "eDP-1" })

hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1", default = true })
hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "0", monitor = "HDMI-A-1" })

-- Scrolling layout for workspace 5
hl.workspace_rule({ workspace = "5", layout = "scrolling", layout_opts = { direction = "down" } })

----------------------------
---- LAYER RULES ----
----------------------------

-- Activate blur for swaync
hl.layer_rule({
    name  = "blur-swaync",
    match = { namespace = "swaync-control-center" },
    blur  = true,
    ignore_alpha = 0.1,
})

----------------------------
---- WINDOW RULES ----
----------------------------

-- KITTY - window title "Snippet Selector"
hl.window_rule({
    name  = "float-snippet-selector",
    match = { title = "Snippet Selector" },
    float = true,
    center = true,
    size = { "monitor_w * 0.9", "monitor_h * 0.9" },
    rounding = 10,
    opacity = "0.95",
})

-- KITTY - window title "AI Prompt Popup"
hl.window_rule({
    name  = "float-ai-prompt",
    match = { title = "AI Prompt Popup" },
    float = true,
    center = true,
    size = { "monitor_w * 0.9", "monitor_h * 0.9" },
    rounding = 10,
    opacity = "0.95",
})

-- KITTY - window title "AI Clipboard Text Actions"
hl.window_rule({
    name  = "float-ai-clipboard",
    match = { title = "AI Clipboard Text Actions" },
    float = true,
    center = true,
    size = { "monitor_w * 0.9", "monitor_h * 0.9" },
    rounding = 10,
    opacity = "0.95",
})

-- KITTY - window title "Commands Cheatsheets"
hl.window_rule({
    name  = "float-commands-cheatsheet",
    match = { title = "Commands Cheatsheets" },
    float = true,
    center = true,
    size = { "monitor_w * 0.9", "monitor_h * 0.9" },
})

-- GNOME Loupe - image viewer
hl.window_rule({
    name  = "loupe-fullscreen-ws3",
    match = { class = "org.gnome.Loupe" },
    workspace = "3",
    fullscreen = true,
})

-- Set Kitty terminal opacity to 0.8
hl.window_rule({
    name  = "kitty-opacity",
    match = { class = "kitty" },
    opacity = "0.8",
})