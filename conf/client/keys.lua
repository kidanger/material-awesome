local awful = require('awful')
require('awful.autofocus')
local modkey = require('conf.keys.mod').modKey
local altkey = require('conf.keys.mod').altKey

local clientKeys =
  awful.util.table.join(
  --awful.key(
    --{modkey},
    --'f',
    --function(c)
      --c.fullscreen = not c.fullscreen
      --c:raise()
    --end,
    --{description = 'toggle fullscreen', group = 'client'}
  --),
  --awful.key(
    --{modkey},
    --'q',
    --function(c)
      --c:kill()
    --end,
    --{description = 'close', group = 'client'}
  --)
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c)
              if c.name ~= 'Xephyr on :2.0 (ctrl+shift grabs mouse and keyboard)' then
                c:kill()
              end
          end, {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "a",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)

return clientKeys
