local awful = require('awful')
local placement = require("awful.placement")
local LeftPanel = require('widgets.left-panel')
local TopPanel = require('widgets.top-panel')

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(
  function(s)
    if s.index == 1 or true then
      -- Create the leftPanel
      s.left_panel = LeftPanel(s)
      -- Create the Top bar
      --s.top_panel = TopPanel(s, true)

      placement.left(s.left_panel, {
        attach          = true,
        update_workarea = true,
        margins         = s.width,
      })
    else
      -- Create the Top bar
      --s.top_panel = TopPanel(s, false)
    end
  end
)

