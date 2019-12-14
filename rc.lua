local gears = require('gears')
local awful = require('awful')
require('awful.autofocus')
local beautiful = require('beautiful')
local filesystem = require('gears.filesystem')

-- Theme
beautiful.init(require('theme'))

-- Init all modules
require('module.notifications')
require('module.auto-start')
require('module.decorate-client')
require('module.backdrop')
require('module.panel')
require('module.exit-screen')
--require('module.quake-terminal')

if false then
require('luarocks.loader')
local icon_finder = require('module.icon-finder')
iconapps_dir = {
  filesystem.get_configuration_dir() .. "theme/icons/",
  --"/usr/share/icons/Papirus/16x16/",
  --"/usr/share/icons/Papirus/16x16/",
  --"/usr/share/icons/oxygen/base/16x16/",
  --"/usr/share/icons/hicolor/16x16/",
  --"/usr/share/icons/gnome/16x16/",
  --"/usr/share/icons/Tango/16x16/",
  "/usr/share/icons/Adwaita/16x16/",
  "/usr/share/icons/default/",
  "/usr/share/icons/HighContrast/16x16/",
  "/usr/share/pixmaps/",
}
_G.iconfinder = icon_finder.new(iconapps_dir)
end

-- Setup all configurations
require('conf.client')
require('conf.tags')
_G.root.keys(require('conf.keys.global'))

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(
  function(s)
    -- If wallpaper is a function, call it with the screen
    gears.wallpaper.set(beautiful.wallpaper, 1, true)
  end
)

-- Signal function to execute when a new client appears.
_G.client.connect_signal(
  'manage',
  function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not _G.awesome.startup then
      awful.client.setslave(c)
    end

    if _G.awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
    end
  end
)

-- Enable sloppy focus, so that focus follows mouse.

_G.client.connect_signal(
  'mouse::enter',
  function(c)
    c:emit_signal('request::activate', 'mouse_enter', {raise = true})
  end
)

_G.client.connect_signal(
  'focus',
  function(c)
    c.border_color = beautiful.border_focus
  end
)
_G.client.connect_signal(
  'unfocus',
  function(c)
    c.border_color = beautiful.border_normal
  end
)

tag.connect_signal("request::screen", function(t)
    for s in screen do
        if s ~= t.screen and
           s.geometry.x == t.screen.geometry.x and
           s.geometry.y == t.screen.geometry.y and
           s.geometry.width == t.screen.geometry.width and
           s.geometry.height == t.screen.geometry.height then
            local t2 = awful.tag.find_by_name(s, t.name)
            if t2 then
                t:swap(t2)
            else
                t.screen = s
            end
            return
        end
    end
end)

client.connect_signal("property::minimized", function(c)
    c.minimized = false
end)

