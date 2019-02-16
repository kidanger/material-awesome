local awful = require('awful')
local gears = require('gears')
local icons = require('theme.icons')

local tags = {
  {
    icon = icons.chrome,
    type = 'chrome',
    defaultApp = 'google-chrome-beta',
    screen = 1
  },
  {
    icon = icons.code,
    type = 'code',
    defaultApp = 'code',
    screen = 1
  },
  {
    icon = icons.social,
    type = 'social',
    defaultApp = 'station',
    screen = 1
  },
  {
    icon = icons.folder,
    type = 'files',
    defaultApp = 'nautilus',
    screen = 1
  },
  {
    icon = icons.music,
    type = 'music',
    defaultApp = 'youtube-music',
    screen = 1
  },
  {
    icon = icons.game,
    type = 'game',
    defaultApp = '',
    screen = 1
  },
  {
    icon = icons.lab,
    type = 'any',
    defaultApp = '',
    screen = 1
  },
  {
    icon = icons.lab,
    type = 'any',
    defaultApp = '',
    screen = 1
  },
  {
    icon = icons.lab,
    type = 'any',
    defaultApp = '',
    screen = 1
  }
}

awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.max,
}

mtags = {}
awful.screen.connect_for_each_screen(
  function(s)
    --if true then return end
    for i, tag in ipairs(tags) do
      local truei = i
      if j == 2 then
        truei = truei + #tags
      end
      local layout = awful.layout.suit.tile
      if i == 9 then
        layout = awful.layout.suit.tile.bottom
      end
      local new_tag = awful.tag.add(truei, {
          icon = tag.icon,
          icon_only = true,
          layout = layout,
          gap_single_client = false,
          gap = 2,
          screen = s,
          defaultApp = tag.defaultApp,
          selected = truei == 1
        })
    end
  end
)
awful.screen.connect_for_each_screen(
  function(s)
    if true then return end
    if s == screen.primary then
      -- create the tags, or move them to primary screen
      for j = 1,2 do
        for i, tag in ipairs(tags) do
          local truei = i
          if j == 2 then
            truei = truei + #tags
          end
          mtags[truei] = nil
          if not mtags[truei] then
            local layout = awful.layout.suit.tile
            if i == 9 then
              layout = awful.layout.suit.tile.bottom
            end
            local new_tag = awful.tag.add(truei, {
                icon = tag.icon,
                icon_only = true,
                layout = layout,
                gap_single_client = false,
                gap = 2,
                screen = s,
                defaultApp = tag.defaultApp,
                selected = truei == 1
              })
            mtags[truei] = new_tag
          end
          local t = mtags[truei]
          t.screen = s
          t.selected = truei == 1
        end
      end
    else
      -- TODO: handle more than two screens
      for i, tag in ipairs(tags) do
        local truei = i + #tags
        local t = mtags[truei]
        t.screen = s
        if i == 1 then
          t.selected = true
        end
      end
    end
  end
  )

tag.connect_signal(
  'property::layout',
  function(t)
    local currentLayout = awful.tag.getproperty(t, 'layout')
    if (currentLayout == awful.layout.suit.max) then
      t.gap = 0
    else
      t.gap = 2
    end
  end
)
