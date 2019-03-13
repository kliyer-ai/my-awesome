local awful = require("awful")
local wibox = require("wibox")

return function(s)
    local layoutbox = wibox.container.margin()
    layoutbox.widget = awful.widget.layoutbox(s)
    layoutbox.right = 13
    layoutbox.top = 7
    layoutbox.bottom = 7
    return layoutbox
    -- return wibox.widget {
    --     {
    --         widget = awful.widget.layoutbox(s)
    --     },
    --     widget = wibox.container.margin,
    --     top = 2,
    --     bottom = 2,
    --     right = 10
    -- }
end
