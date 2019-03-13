local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")

local GET_CAPACITY_CMD = "cat /sys/class/power_supply/BAT1/capacity"
local GET_STATUS_CMD = "cat /sys/class/power_supply/BAT1/status"

local battery_text = wibox.widget.textbox()

local battery_icon =
    wibox.widget {
    {
        image = "/usr/share/icons/Arc/status/symbolic/battery-full-symbolic.svg",
        resize = false,
        widget = wibox.widget.imagebox
    },
    top = 7,
    bottom = 7,
    right = 7,
    widget = wibox.container.margin
}

local battery_widget =
    wibox.widget {
    battery_icon,
    battery_text,
    layout = wibox.layout.fixed.horizontal
}

local update = function(widget, stdout, _, _, _)
    local capacity = stdout:gsub("\n", "")
    widget.text = capacity .. "%"
end

watch(GET_CAPACITY_CMD, 30, update, battery_text)

return battery_widget
