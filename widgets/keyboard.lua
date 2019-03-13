local awful = require("awful")
local wibox = require("wibox")

local keyboard_text = awful.widget.keyboardlayout()

local keyboard_icon =
    wibox.widget {
    {
        image = "/usr/share/icons/Arc/panel/22/indicator-keyboard.svg",
        resize = false,
        widget = wibox.widget.imagebox
    },
    top = 5,
    bottom = 5,
    right = 5,
    widget = wibox.container.margin
}

local keyboard_widget =
    wibox.widget {
    keyboard_icon,
    keyboard_text,
    layout = wibox.layout.fixed.horizontal
}

return keyboard_widget
