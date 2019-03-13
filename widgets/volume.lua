-------------------------------------------------
-- Volume Widget for Awesome Window Manager
-- Shows the current volume level
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/volume-widget

-- @author Pavel Makhov
-- @copyright 2018 Pavel Makhov
-------------------------------------------------

local wibox = require("wibox")
local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")

local path_to_icons = "/usr/share/icons/Arc/status/symbolic/"

local GET_VOLUME_CMD = "amixer -D pulse sget Master"
local INC_VOLUME_CMD = "amixer -D pulse sset Master 5%+"
local DEC_VOLUME_CMD = "amixer -D pulse sset Master 5%-"
local TOG_VOLUME_CMD = "amixer -D pulse sset Master toggle"

local volume_text = wibox.widget.textbox()

local volume_icon =
    wibox.widget {
    {
        image = "/usr/share/icons/Arc/status/symbolic/audio-volume-high-symbolic.svg",
        resize = false,
        widget = wibox.widget.imagebox
    },
    top = 7,
    bottom = 7,
    right = 7,
    widget = wibox.container.margin
}

local volume_widget =
    wibox.widget {
    volume_icon,
    volume_text,
    layout = wibox.layout.fixed.horizontal
}

local update_widget = function(widget, stdout, _, _, _)
    local mute = string.match(stdout, "%[(o%D%D?)%]")
    local volume = string.match(stdout, "(%d?%d?%d)%%")
    volume = tonumber(string.format("% 3d", volume))
    if (mute == "on") then
        widget.text = volume .. "%"
    else
        widget.text = "muted"
    end
end

--[[ allows control volume level by:
- clicking on the widget to mute/unmute
- scrolling when cursor is over the widget
]]
volume_text:connect_signal(
    "button::press",
    function(_, _, _, button)
        if (button == 4) then
            spawn(INC_VOLUME_CMD, false)
        elseif (button == 5) then
            spawn(DEC_VOLUME_CMD, false)
        elseif (button == 1) then
            spawn(TOG_VOLUME_CMD, false)
        end

        spawn.easy_async(
            GET_VOLUME_CMD,
            function(stdout, stderr, exitreason, exitcode)
                update_widget(volume_text, stdout, stderr, exitreason, exitcode)
            end
        )
    end
)

watch(GET_VOLUME_CMD, 1, update_widget, volume_text)

return volume_widget
