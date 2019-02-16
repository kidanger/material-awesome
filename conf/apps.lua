local filesystem = require('gears.filesystem')

return {
  terminal = 'terminator',
  rofi = 'rofi -combi-modi window,run -show combi -theme ' .. filesystem.get_configuration_dir() .. '/conf/rofi.rasi',
  lock = 'i3lock-fancy-rapid 5 3',
  quake = 'alacritty --title QuakeTerminal',
}
