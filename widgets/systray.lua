local wibox = require("wibox")

return wibox.widget {
    {
        widget = wibox.widget.systray
    },
    widget = wibox.container.margin,
    top = 2,
    bottom = 2
}
