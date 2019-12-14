-------------------------------------------------
-- Volume Arc Widget for Awesome Window Manager
-- Shows the current volume level
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/volumearc-widget

-- @author Pavel Makhov
-- @copyright 2018 Pavel Makhov
-------------------------------------------------

local awful = require("awful")
local beautiful = require("beautiful")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local GET_VOLUME_CMD = '/home/anger/bin/cputhresholdroot'

local PATH_TO_ICON = "/usr/share/icons/Arc/status/symbolic/audio-volume-muted-symbolic.svg"

local icon = {
    id = "icon",
    image = PATH_TO_ICON,
    resize = true,
    widget = wibox.widget.imagebox,
}

local volumearc = wibox.widget {
    icon,
    max_value = 1,
    thickness = 2,
    start_angle = 4.71238898, -- 2pi*3/4
    forced_height = 18,
    forced_width = 18,
    bg = "#ffffff11",
    paddings = 2,
    widget = wibox.container.arcchart
}

function toMHz(str)
    local cache, done = 0, 0
    if done == 0 then
        cache, done = str:gsub('([0-9%.]+) GHz', function(x) return tonumber(x)*1000 end)
    end
    if done == 0 then
        cache, done = str:gsub('([0-9%.]+) MHz', function(x) return tonumber(x) end)
    end
    return cache
end

local cur = 800
local update_graphic = function(widget, stdout, _, _, _)
    local volume = string.match(stdout, "et (.-).\n.*$")
    volume = toMHz(volume)
    cur = volume

    widget.value = volume / 4400
    widget.colors = volume > 3300 and { beautiful.widget_red }
                                   or { beautiful.widget_main_color }
end

volumearc:connect_signal("button::press", function(_, _, _, button)
    local off = 200
    if (button == 4) then
        awful.spawn(('env FREQ=%d '):format(cur + off) .. GET_VOLUME_CMD, false)
    elseif (button == 5) then
        awful.spawn(('env FREQ=%d '):format(cur - off) .. GET_VOLUME_CMD, false)
    end

    spawn.easy_async(GET_VOLUME_CMD, function(stdout, stderr, exitreason, exitcode)
        update_graphic(volumearc, stdout, stderr, exitreason, exitcode)
    end)
end)
awful.spawn('env FREQ=2000 ' .. GET_VOLUME_CMD, false)

watch(GET_VOLUME_CMD, 30, update_graphic, volumearc)

return wibox.container.mirror(volumearc, {horizontal=true})

