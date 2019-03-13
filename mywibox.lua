-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")

local volume_widget = require("widgets.volume")
local battery_widget = require("widgets.battery")
local keyboard_widget = require("widgets.keyboard")
local brightness_widget = require("widgets.brightness")
local systray_widget = require("widgets.systray")
local textclock_widget = require("widgets.textclock")
local separator_widget = require("widgets.separator")
local layoutbox_widget = require("widgets.layoutbox")

beautiful.init(awful.util.getdir("config") .. "themes/default/theme.lua")

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({theme = {width = 250}})
        end
    end
end
-- }}}

-- Create a wibox for each screen and add it
local taglist_buttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(t)
            t:view_only()
        end
    ),
    awful.button(
        {modkey},
        1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
    ),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button(
        {modkey},
        3,
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end
    ),
    awful.button(
        {},
        4,
        function(t)
            awful.tag.viewnext(t.screen)
        end
    ),
    awful.button(
        {},
        5,
        function(t)
            awful.tag.viewprev(t.screen)
        end
    )
)

local tasklist_buttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(c)
            if c == client.focus then
                c.minimized = true
            else
                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
                -- This will also un-minimize
                -- the client, if needed
                client.focus = c
                c:raise()
            end
        end
    ),
    awful.button({}, 3, client_menu_toggle_fn()),
    awful.button(
        {},
        4,
        function()
            awful.client.focus.byidx(1)
        end
    ),
    awful.button(
        {},
        5,
        function()
            awful.client.focus.byidx(-1)
        end
    )
)

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(
    function(s)
        -- Wallpaper
        set_wallpaper(s)

        -- Each screen has its own tag table.
        awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9"}, s, awful.layout.layouts[1])

        -- Create a promptbox for each screen
        s.mypromptbox = awful.widget.prompt()
        -- Create an imagebox widget which will contain an icon indicating which layout we're using.
        -- We need one layoutbox per screen.
        s.mylayoutbox = layoutbox_widget(s)
        s.mylayoutbox:buttons(
            gears.table.join(
                awful.button(
                    {},
                    1,
                    function()
                        awful.layout.inc(1)
                    end
                ),
                awful.button(
                    {},
                    3,
                    function()
                        awful.layout.inc(-1)
                    end
                ),
                awful.button(
                    {},
                    4,
                    function()
                        awful.layout.inc(1)
                    end
                ),
                awful.button(
                    {},
                    5,
                    function()
                        awful.layout.inc(-1)
                    end
                )
            )
        )
        -- Create a taglist widget
        s.mytaglist =
            awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons, {squares_resize = "true"})

        -- Create a tasklist widget
        s.mytasklist =
            awful.widget.tasklist(
            s,
            awful.widget.tasklist.filter.currenttags,
            tasklist_buttons,
            {
                spacing = 10,
                shape_border_width = 30,
                shape_border_width_minimized = 30,
                shape_border_width_focused = 30,
                align = "center"
            }
        )

        s.textclock = textclock_widget(s)

        -- s.mysystray = widgets.systray()

        -- Create the wibox
        s.mywibox = awful.wibar({position = "bottom", screen = s, height = 30})

        -- Add widgets to the wibox
        s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            expand = "none",
            {
                -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                -- mylauncher,
                s.mytaglist,
                s.mypromptbox
            },
            -- s.mytasklist, -- Middle widget
            s.textclock,
            {
                -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                systray_widget,
                separator_widget,
                keyboard_widget,
                separator_widget,
                brightness_widget,
                separator_widget,
                volume_widget,
                separator_widget,
                battery_widget,
                --separator_widget,
                --widgets.textclock,
                separator_widget,
                s.mylayoutbox
            }
        }
    end
)
