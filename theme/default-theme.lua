local filesystem = require('gears.filesystem')
local mat_colors = require('theme.mat-colors')
local theme_dir = filesystem.get_configuration_dir() .. '/theme'
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local theme = {}
theme.icons = theme_dir .. '/icons/'
theme.font = 'Roboto medium 10'

-- Colors Pallets

-- Primary
theme.primary = mat_colors.deep_orange

-- Accent
theme.accent = mat_colors.pink

-- Background
theme.background = mat_colors.grey
theme.other = mat_colors.grey

local main = theme.background.hue_850
local weak = theme.background.hue_450
local back = theme.background.hue_200
T_MAIN = main
T_WEAK = weak
T_BACK = back


local awesome_overrides =
  function(theme)
  theme.dir = os.getenv('HOME') .. '/.config/awesome/theme'
  --theme.dir             = os.getenv("HOME") .. "/code/awesome-pro/themes/pro-dark"

  theme.icons = theme.dir .. '/icons/'
  --theme.wallpaper = theme.dir .. '/wallpapers/pro-dark-shadow.png'
  --theme.wallpaper = '#A0A0A0'
  theme.wallpaper = '#EEEEEE'
  theme.wallpaper = '#cccccc'
  --theme.wallpaper = '#ffffff'
  theme.font = 'Roboto medium 10'
  theme.title_font = 'Roboto medium 14'

  theme.fg_normal = '#ffffffde'

  theme.fg_focus = '#e4e4e4'
  theme.fg_urgent = '#CC9393'
  theme.bat_fg_critical = '#232323'

  theme.bg_normal = main
  theme.bg_focus = '#5a5a5a'
  theme.bg_urgent = '#3F3F3F'
  theme.bg_systray = main

  -- Borders

  theme.border_width = dpi(5)
  theme.border_normal = main
  theme.border_focus = weak
  theme.border_marked = '#CC9393'

  -- Menu

  theme.menu_height = dpi(16)
  theme.menu_width = dpi(160)

  -- Tooltips
  theme.tooltip_bg = '#232323'
  --theme.tooltip_border_color = '#232323'
  theme.tooltip_border_width = 5
  theme.tooltip_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, dpi(6))
  end

  -- Layout

  theme.layout_max = theme.icons .. 'layouts/arrow-expand-all.png'
  theme.layout_tile = theme.icons .. 'layouts/view-quilt.png'

  -- Taglist

  theme.taglist_bg_empty = back
  theme.taglist_bg_urgent =
    'linear:0,0:' ..
    dpi(48) ..
      ',0:0,' ..
        theme.accent.hue_700 ..
          ':0.1,' .. theme.accent.hue_700 .. ':0.1,' .. back .. ':1,' .. back

  theme.taglist_bg_occupied =
    'linear:0,0:' .. dpi(28) .. ',0:0,' .. theme.other.hue_200 .. ':0.75,' .. theme.other.hue_200 .. ':0.75,' .. weak .. ':0.85,' .. weak .. ':0.85,' .. back .. ':1,' .. back
  theme.taglist_bg_focus =
    'linear:0,0:' .. dpi(28) .. ',0:0,' .. theme.other.hue_200 .. ':0.75,' .. theme.other.hue_200 .. ':0.75,' .. main .. ':0.85,' .. main .. ':0.85,' .. back .. ':1,' .. back

  -- Tasklist

  theme.tasklist_font = 'Roboto medium 11'
  theme.tasklist_bg_normal = theme.background.hue_800
  theme.tasklist_bg_focus =
    'linear:0,0:0,' ..
    dpi(48) ..
      ':0,' ..
        theme.background.hue_800 ..
          ':0.95,' .. theme.background.hue_800 .. ':0.95,' .. theme.fg_normal .. ':1,' .. theme.fg_normal
  theme.tasklist_bg_urgent = theme.primary.hue_800
  theme.tasklist_fg_focus = '#DDDDDD'
  theme.tasklist_fg_urgent = theme.fg_normal
  theme.tasklist_fg_normal = '#AAAAAA'

  theme.icon_theme = 'Papirus-Dark'

  --Client
  theme.border_width = dpi(2)
  theme.border_focus = main
  theme.border_normal = weak
end
return {
  theme = theme,
  awesome_overrides = awesome_overrides
}
