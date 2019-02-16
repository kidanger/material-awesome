local awful = require('awful')
local LeftPanel = require('widgets.left-panel')
local TopPanel = require('widgets.top-panel')

local useTopPanel = false

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(
  function(s)
    if s.index == 1 or true then
      -- Create the leftPanel
      s.left_panel = LeftPanel(s)
      -- Create the Top bar
      if useTopPanel then
        s.top_panel = TopPanel(s, true)
      end
    else
      -- Create the Top bar
      if useTopPanel then
        s.top_panel = TopPanel(s, false)
      end
    end
  end
)

-- Hide bars when app go fullscreen
function updateBarsVisibility(s)
  if not s then return end
  local t = s.selected_tag
  if t then
    local fullscreen = false
    for _, c in pairs(t:clients()) do
      if c.fullscreen then
        fullscreen = true
        break
      end
    end
    -- Order matter here for shadow
    if s.top_panel then
      s.top_panel.visible = not fullscreen
    end
    if s.left_panel then
      s.left_panel.visible = not fullscreen
    end
  end
end

_G.tag.connect_signal(
  'property::selected',
  function(t)
    updateBarsVisibility(t.screen)
  end
)

_G.client.connect_signal(
  'property::fullscreen',
  function(c)
    updateBarsVisibility(c.screen)
  end
)

_G.client.connect_signal(
  'unmanage',
  function(c)
    updateBarsVisibility(c.screen)
  end
)


