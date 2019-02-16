local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local TagList = require('widgets.tag-list')
local gears = require('gears')
local apps = require('conf.apps')
local dpi = require('beautiful').xresources.apply_dpi

local mat_list_item = require('widgets.mat-list-item')
-- Clock / Calendar 24h format
local textclock = wibox.widget.textclock('<span font="Roboto Mono bold 11">%H\n%M</span>')
local TaskList = require('widgets.task-list')

local LeftPanel =
  function(s)
  -- Clock / Calendar 12AM/PM fornat
  -- local textclock = wibox.widget.textclock('<span font="Roboto Mono bold 11">%I\n%M</span>\n<span font="Roboto Mono bold 9">%p</span>')
  -- textclock.forced_height = 56
  local clock_widget = wibox.container.margin(textclock, dpi(3), dpi(3), dpi(3), dpi(3))
  local systray = wibox.widget.systray()
  systray:set_horizontal(false)
  local clickable_container = require('widgets.clickable-container')
  local icons = require('theme.icons')

  local menu_icon =
    wibox.widget {
    image = icons.menu,
    widget = wibox.widget.imagebox
  }

  local home_button =
    wibox.widget {
    wibox.widget {
      wibox.widget {
        wibox.container.margin(menu_icon, 5, 5, 5, 5),
        top = 1,
        left = 1,
        right = 1,
        bottom = 1,
        widget = wibox.container.margin
      },
      widget = clickable_container
    },
    bg = beautiful.primary.hue_500,
    widget = wibox.container.background
  }

  local size = 28
  local panel =
    wibox {
    screen = s,
    width = dpi(size),
    height = s.geometry.height,
    x = s.geometry.x + dpi(size) - dpi(size),
    y = s.geometry.y,
    ontop = true,
    bg = beautiful.background.hue_800,
    fg = beautiful.fg_normal
  }
  panel.minwidth = size

  --s:connect_signal('property::geometry', function()
    --panel.x = s.geometry.x
    --panel.y = s.geometry.y
    --panel.height = s.geometry.height
  --end)

  panel.opened = false

  panel:struts(
    {
      left = dpi(size)
    }
  )

  local backdrop =
    wibox {
    ontop = true,
    screen = s,
    bg = '#00000000',
    type = 'dock',
    x = s.geometry.x,
    y = s.geometry.y,
    width = s.geometry.width,
    height = s.geometry.height
  }

  local run_rofi =
    function()
    awesome.spawn(
      apps.rofi,
      false,
      false,
      false,
      false,
      function()
        panel:toggle()
      end
    )
  end

  local openPanel = function(should_run_rofi)
    menu_icon.image = icons.close
    run_rofi()
  end

  local closePanel = function()
    menu_icon.image = icons.menu
    backdrop.visible = false
  end

  function panel:toggle(should_run_rofi)
    self.opened = not self.opened
    if self.opened then
      openPanel(should_run_rofi)
    else
      closePanel()
    end
  end

  backdrop:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          panel:toggle()
        end
      )
    )
  )

  home_button:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()
          panel:toggle()
          --awful.spawn(apps.rofi)
        end
      )
    )
  )

  local search_button =
    wibox.widget {
    wibox.widget {
      {
        wibox.widget {
          image = icons.search,
          widget = wibox.widget.imagebox
        },
        left = 12,
        right = 12,
        top = 12,
        bottom = 12,
        widget = wibox.container.margin
      },
      margins = dpi(3),
      widget = wibox.container.margin
    },
    wibox.widget {
      text = 'Search Applications',
      font = 'Roboto medium 13',
      widget = wibox.widget.textbox
    },
    clickable = true,
    widget = mat_list_item
  }

  search_button:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          run_rofi()
        end
      )
    )
  )

  local exit_button =
    wibox.widget {
    wibox.widget {
      wibox.widget {
        image = icons.logout,
        widget = wibox.widget.imagebox
      },
      margins = dpi(12),
      widget = wibox.container.margin
    },
    wibox.widget {
      text = 'End work session',
      font = 'Roboto medium 13',
      widget = wibox.widget.textbox
    },
    clickable = true,
    divider = true,
    widget = mat_list_item
  }

  exit_button:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          panel:toggle()
          exit_screen_show()
        end
      )
    )
  )

  local lb = awful.widget.layoutbox(s)

  panel:setup {
    layout = wibox.layout.align.vertical,
    forced_width = dpi(size),
    {
      layout = wibox.layout.fixed.vertical,
      home_button,
      -- Create a taglist widget
      TagList(s),
    },
    TaskList(s),
    {
      layout = wibox.layout.fixed.vertical,
      wibox.container.margin(systray, 5, 5),
      require('widgets.package-updater'),
      --require('widgets.wifi'),
      --require('widgets.battery'),
      -- Clock
      clock_widget,
      lb,
    }
  }

  return panel
end

return LeftPanel
