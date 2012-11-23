-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- Vicious
--require("vicious")
vicious = require("vicious")
vicious.contrib = require("vicious.contrib")
vicious.helpers = require("vicious.helpers")
vicious.widgets = require("vicious.widgets")

-- Load Debian menu entries
require("debian.menu")

require("beautiful") -- Темы

require("utility")
require("awful/widget/calendar2")

require("revelation")

--require("shifty")
require("eminent")

-- useful for debugging, marks the beginning of rc.lua exec
print("Entered rc.lua: " .. os.time())

os.setlocale('ru_RU.UTF-8') --}}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}


--
--local vars
wallpaperdir = "/home/kirill/.config/awesome/backgrounds/"
fss = {--Показывать место
    {"/home", "h"},
    {"/", "/"}
}

--}local vars

--{{{Таймеры
mytimer3 = timer({ timeout = 3 })
mytimer2 = timer({ timeout = 2 })
mytimer1800 = timer({ timeout = 1800 })
mytimer600 = timer({ timeout = 600 })
mytimer10 = timer({ timeout = 10 })
--Таймеры}}}

--{{{Функция смены обоев
function wpchange()
    awful.util.spawn("awsetbg -c -r " .. wallpaperdir)
end

-- Менять обои каждые 1800 секунд
mytimer1800:add_signal("timeout", function() awful.util.spawn("awsetbg -f -r /home/kirill/.config/awesome/backgrounds/") end)
--Функция смены обоев}}

autorun = true
 
autorunApps = --Приложения, которым нужен перезапуск при перезапуске AwesomeWM
   {
   "kbdd",
}
 
runOnceApps = --Приложения, при перезапуске которых появляется нежелательная вторая копия
   {
    "dropbox start",
    "nm-applet",
    "gnome-settings-daemon",
    "pasystray",
    "conky",
    -- "awsetbg ~/",
}
 
if autorun then
   for app = 1, #autorunApps do
      awful.util.spawn(autorunApps[app])
   end
   for app = 1, #runOnceApps do
      utility.run_once(runOnceApps[app])
   end
end


-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init(awful.util.getdir("config") .. "/themes/zhongguo/zhongguo.lua")

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
--editor = "gedit"--os.getenv("EDITOR") or "editor"
editor = "vim"
editor_cmd = terminal .. " -e " .. editor

-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating, --1
    awful.layout.suit.tile, --2
    awful.layout.suit.tile.left, --3
    awful.layout.suit.tile.bottom, --4
    awful.layout.suit.tile.top, --5
    awful.layout.suit.fair, --6
    awful.layout.suit.fair.horizontal, --7
    awful.layout.suit.spiral, --8
    awful.layout.suit.spiral.dwindle, --9
    awful.layout.suit.max, --10
    awful.layout.suit.max.fullscreen, --11
    awful.layout.suit.magnifier --12
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags
-- taglist numerals
--- arabic, chinese, {east|persian}_arabic, roman, thai, random
taglist_numbers = "chinese" -- we support arabic (1,2,3...),

st_numbers_langs = { 'arabic', 'chinese', 'east_arabic', 'persian_arabic', }
taglist_numbers_sets = {
    arabic = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
    chinese = {"一", "二", "三", "四", "五", "六", "七", "八", "九", "十"},
    east_arabic = {'١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'}, -- '٠' 0
    persian_arabic = {'٠', '١', '٢', '٣', '۴', '۵', '۶', '٧', '٨', '٩'},
    roman ={ 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X'},
    thai = {'๑', '๒', '๓', '๔', '๕', '๖', '๗', '๘', '๙', '๑๐'},
    greek = { "α", "β", "γ", "δ", "ε", "ζ", "η", "θ", "Ι", "Κ", "λ", "μ", "ν", "ξ", "π", "σ", "τ", "φ", "χ", "ψ", "ω" }
}

tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    --tags[s] = awful.tag({ "w", "B", "T", 4, 5, 6, 7, 8, 9 }, s, layouts[1])
    --tags[s] = awful.tag({ "α", "β", "γ", "δ", "ε", "η", "θ", "λ", "ω" }, s, layouts[1])
    --tags[s] = awful.tag({"一", "二", "三", "四", "五", "六", "七", "八", "九", "十"}, s, layouts[1])
    if taglist_numbers == 'random' then
        math.randomseed(os.time())
        local taglist = taglist_numbers_sets[taglist_numbers_langs[math.random(table.getn(taglist_numbers_langs))]]
        tags[s] = awful.tag(taglist, s, layouts[1])
    else
        tags[s] = awful.tag(taglist_numbers_sets[taglist_numbers], s, layouts[1])
    end
end

--Tags with default layout
awful.layout.set(layouts[10], tags[1][2])
awful.layout.set(layouts[1], tags[1][1])
awful.layout.set(layouts[3], tags[1][3])
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mysystemmenu = {
   {  "Reboot", terminal .. " -e sudo reboot" },
   {  "shutdown", terminal .. " -e sudo shutdown 1" },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian menu", debian.menu.Debian_menu.Debian },
                                    { "sys", mysystemmenu },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Battery widget
--batwidget = awful.widget.progressbar()

--vicious.register(batwidget, vicious.widgets.bat, "$2", 61, "BAT0")

-- }}}

--{{{ Battery state

-- Initialize widget
batwidget = widget({ type = "textbox" })
baticon = widget({ type = "imagebox" })

-- Register widget
vicious.register(batwidget, vicious.widgets.bat,
	function (widget, args)
		if args[2] == 0 then return ""
		else
			baticon.image = image(beautiful.widget_bat)
			return "<span color='white'>".. args[2] .. "%</span>"
		end
	end, 61, "BAT0"
)
-- }}}

-- {{{ Wibox
-- Create a textclock widget
--mytextclock = awful.widget.textclock({ align = "right" })
mytextclock = awful.widget.textclock({ align = "right" }, "<i>%a</i> %d %b, %H:%M:%S", 1)
calendar2.addCalendarToWidget(mytextclock, "<span color='green'>%s</span>")

--{{{Splitter (разделитель)
sp = widget({ type = "textbox" })
sp.text = " :: "

--Splitter (разделитель)}}}
-- text box{
mytextbox = widget({ type = "textbox" })
mytextbox.text = "CW"
mytextbox:buttons(awful.util.table.join(
   awful.button({ }, 1, function () awful.util.spawn("awsetbg -f -r /home/kirill/.config/awesome/backgrounds/") end)
 ))
--textbox}

--lang
kbdwidget = widget({type = "textbox", name = "kbdwidget"})
kbdwidget.border_color = beautiful.fg_normal
kbdwidget.text = "Eng"

dbus.request_name("session", "ru.gentoo.kbdd") 
dbus.add_match("session", "interface='ru.gentoo.kbdd',member='layoutChanged'") 
dbus.add_signal("ru.gentoo.kbdd", function(...) 
    local data = {...} 
    local layout = data[2] 
    lts = {[0] = "Eng", [1] = "Рус"} 
    kbdwidget.text = " "..lts[layout].." " 
    end 
) 
--end lang
--mem
memwidget = widget({ type = "textbox" })
vicious.cache(vicious.widgets.mem)
vicious.register(memwidget, vicious.widgets.mem, "$1 ($2MB/$3MB)", 13)
--end mem
-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a volume widget 
--volumewidget = widget({ type = 'textbox'}) 
--vicious.cache(vicious.widgets.volume) 
--vicious.register(volumewidget, vicious.widgets.volume, 'Vol: $1% |', 1, "Master") 
--end volume


-- {{{ Volume level
volicon = widget({ type = "imagebox" })
volicon.image = image(beautiful.widget_vol)
-- Initialize widgets
volbar    = awful.widget.progressbar()
volwidget = widget({ type = "textbox" })
-- Progressbar properties
volbar:set_vertical(true):set_ticks(true)
volbar:set_height(16):set_width(8):set_ticks_size(2)
volbar:set_background_color(beautiful.fg_off_widget)
volbar:set_gradient_colors({ beautiful.fg_widget,
   beautiful.fg_center_widget, beautiful.fg_end_widget
}) -- Enable caching
vicious.cache(vicious.widgets.volume)
-- Register widgets
vicious.register(volbar,    vicious.widgets.volume,  "$1",  2, "Master -c0")
vicious.register(volwidget, vicious.widgets.volume, " $1%", 2, "Master -c0")

-- }}}

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
     mywibox[s].widgets = {
        {
            mylauncher, 
            mytaglist[s], sp, 
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright,
        }, 
        mylayoutbox[s], sp, 
        mytextbox, sp, 
        --mytextclock, sp, --memwidget, batwidget,volumewidget, 
        baticon.image and sep, batwidget, baticon or nil, sp,
        volwidget,  volbar.widget, volicon, sp,
        kbdwidget,  sp, 
        s == 1 and mysystray or nil, sp, mytextclock, sp,
        mytasklist[s], sp, 
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey }, "b",
       function ()
           if mywibox[mouse.screen].screen == nil then
               mywibox[mouse.screen].screen = mouse.screen
           else
               mywibox[mouse.screen].screen = nil
           end
       end),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey}, "e", revelation),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey}, "g", function () awful.util.spawn("google-chrome") end),
    awful.key({ modkey}, "c", function () awful.util.spawn("sakura -x zsh") end),
    awful.key({ modkey}, "a", function () awful.util.spawn("gnome-terminal -x ranger") end),
    awful.key({modkey, "Control"}, "n", function() awful.util.spawn("awsetbg -f -r /home/kirill/.config/awesome/backgrounds/") end),
    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
	awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    { rule = { class = "Google-chrome" },
       properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    --awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("manage", function (c, startup)
    c.size_hints_honor = false
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


wpchange()

mytimer1800:start()
--mytimer10:start()
--mytimer3:start()

