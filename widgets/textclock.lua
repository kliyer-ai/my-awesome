local wibox = require("wibox")
local awful = require("awful")

return function(s)
    local textclock = wibox.widget.textclock("<b>%a %d %b, %H:%M</b>")
    local month_calendar =
        awful.widget.calendar_popup.month(
        {
            screen = s,
            opacity = 0.95
        }
    )
    month_calendar:attach(textclock, "bm")
    return textclock
end
