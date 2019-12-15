local awful = require('awful')
local gears = require('gears')
local icons = require('theme.icons')

local tags = {
  {
    icon = icons.void,
    type = 'chrome',
    defaultApp = 'google-chrome-beta',
    screen = 1
  },
  {
    icon = icons.void,
    type = 'code',
    defaultApp = 'code',
    screen = 1
  },
  {
    icon = icons.void,
    type = 'any',
    defaultApp = '',
    screen = 1
  },
  {
    icon = icons.void,
    type = 'any',
    defaultApp = '',
    screen = 1
  },
  {
    icon = icons.void,
    type = 'any',
    defaultApp = '',
    screen = 1
  },
  {
    icon = icons.void,
    type = 'any',
    defaultApp = '',
    screen = 1
  },
  {
    icon = icons.void,
    type = 'any',
    defaultApp = '',
    screen = 1
  },
  {
    icon = icons.void,
    type = 'any',
    defaultApp = '',
    screen = 1
  },
  {
    icon = icons.void,
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

mtags = {}
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

local cache = {}
local fallback = icons.void

local function update_tag_icon(t)
  if not _G.iconfinder then return end
  local bestc = nil
  local bestn = -1
  for _, c in ipairs(t:clients()) do
    if c.lastfocus and c.lastfocus > bestn then
      bestc = c
      bestn = c.lastfocus
    end
  end

  if not bestc or not bestc.class then
    t.icon = fallback
    return
  end

  local name = bestc.class
  if false then
  elseif bestc.name and bestc.name:match 'Gmail' then
    name = 'gmail'
  elseif bestc.name and bestc.name:match 'Slack' then
    name = 'slack'
  elseif name == 'Terminator' then
    name = 'gnome-terminal'
  end
  cache[name] = cache[name]
             or _G.iconfinder:find(name)
             or _G.iconfinder:find(name:lower())
             or fallback
  t.icon = cache[name]
end

local n = 0
_G.client.connect_signal(
  'focus',
  function(c)
    c.lastfocus = n
    n = n + 1
    for _, t in ipairs(c:tags()) do
      update_tag_icon(t)
    end
  end
)
_G.client.connect_signal(
  'unfocus',
  function(c)
    for _, t in ipairs(c:tags()) do
      update_tag_icon(t)
    end
  end
)
_G.tag.connect_signal(
  'tagged',
  function(t)
    update_tag_icon(t)
  end
)
_G.tag.connect_signal(
  'untagged',
  function(t)
    update_tag_icon(t)
  end
)

