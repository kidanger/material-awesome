local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local TaskList = require('widgets.task-list')
local gears = require('gears')
local clickable_container = require('widgets.clickable-container')
local mat_icon_button = require('widgets.mat-icon-button')
local apps = require('conf.apps')
local dpi = require('beautiful').xresources.apply_dpi

local icons = require('theme.icons')
if false then
local add_button = mat_icon_button(wibox.widget.imagebox(icons.plus))
add_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn(
          awful.screen.focused().selected_tag.defaultApp,
          {
            tag = _G.mouse.screen.selected_tag,
            placement = awful.placement.bottom_right
          }
        )
      end
    )
  )
)
end

-- Create an imagebox widget which will contains an icon indicating which layout we're using.
-- We need one layoutbox per screen.
local LayoutBox =
  function(s)
  local layoutBox = clickable_container(awful.widget.layoutbox(s))
  layoutBox:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          awful.layout.inc(1)
        end
      ),
      awful.button(
        {},
        3,
        function()
          awful.layout.inc(-1)
        end
      ),
      awful.button(
        {},
        4,
        function()
          awful.layout.inc(1)
        end
      ),
      awful.button(
        {},
        5,
        function()
          awful.layout.inc(-1)
        end
      )
    )
  )
  return layoutBox
end

local TopPanel =
  function(s)
  local offsetx = 0
  if s.left_panel then
    offsetx = s.left_panel.minwidth
  end
  local size = 24
  local panel =
    wibox(
    {
      ontop = true,
      screen = s,
      height = dpi(size),
      width = s.geometry.width - offsetx,
      x = s.geometry.x + offsetx,
      y = s.geometry.y,
      stretch = false,
      bg = beautiful.background.hue_800,
      fg = beautiful.fg_normal,
      struts = {
        top = dpi(size)
      }
    }
  )

  panel:struts(
    {
      top = dpi(size)
    }
  )

  panel:setup {
    layout = wibox.layout.align.horizontal,
    {
      layout = wibox.layout.fixed.horizontal,
      -- Create a taglist widget
      TaskList(s),
      add_button
    },
    nil,
    {
      layout = wibox.layout.fixed.horizontal,
      -- Layout box
      LayoutBox(s)
    }
  }
  panel.height = size
  print('jan')
  -- local test = panel:get_children_by_id('test')[1]
  gears.debug.dump(test)
  return panel
end

return TopPanel
