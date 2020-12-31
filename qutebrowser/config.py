# Autogenerated config.py
# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html


# Uncomment this to still load settings configured via autoconfig.yml
# This is here so configs done via the GUI are still loaded.
# Remove it to not load settings done via the GUI.
config.load_autoconfig()

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'file://*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'chrome://*/*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'qute://*/*')

# Whether quitting the application requires a confirmation.
# Valid values:
#   - always: Always show a confirmation.
#   - multiple-tabs: Show a confirmation if multiple tabs are opened.
#   - downloads: Show a confirmation if downloads are running
#   - never: Never show a confirmation.
c.confirm_quit = ["downloads"]

# The directory to save downloads to. If unset, a sensible os-specific
# default is used.
c.downloads.location.directory = "~/Downloads"


## URL parameters to strip with `:yank url`.
## Type: List of String
c.url.yank_ignored_parameters = [
    'ref',
    'utm_source',
    'utm_medium',
    'utm_campaign',
    'utm_term',
    'utm_content',
]


c.url.searchengines = {
    'DEFAULT': 'https://www.google.com/search?q={}',
    'gg': 'https://www.google.com/search?q={}',
    'arw': 'https://wiki.archlinux.org/?search={}',
    'ddg': 'https://duckduckgo.com/?q={}',
    'urb': 'https://www.urbandictionary.com/define.php?term={}',
    'gh': 'https://github.com/search?q={}',
    'wi': 'https://en.wikipedia.org/wiki/Special:Search?search={}',
    'yt': 'https://youtube.com/results?search_query={}',
}

config.bind(
    'tt',
    'config-cycle tabs.show always never;; config-cycle statusbar.hide true false',
)

config.bind('ytdl', 'spawn flatpak-spawn --host mpv --really-quiet {url}')