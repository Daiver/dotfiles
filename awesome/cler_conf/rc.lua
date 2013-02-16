-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
vicious = require("vicious")
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

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
 theme_d = awful.util.getdir("config") .. "/themes/"
 my_icons = theme_d .. "zen/icons/"
 beautiful.init(theme_d .. "zen/theme.lua")
-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
fm = "spacefm "
home = os.getenv("HOME")
books = " " .. home .. "/books"
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
names = {"א", "ב", "ג", "ד", "ה", "ו"},
layout = {layouts[1], layouts[1], layouts[2], layouts[4], layouts[6], layouts[10] }
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
end

-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu

mygamesmenu = {
   { "Freeciv", "freeciv-gtk2" },
   { "Tuxmath", "tuxmath" },
   { "Tremulous", "tremulous" }
}

myutilsmenu = {
   { "Password manager", "fpm2" },
   { "Sticky Notes", "xpad" },	
   { "File Manager", fm },
   { "Dictionary", "stardict" },
   { "Notes", "zim" },
   { "Text editor", "gvim" },
   { "Gcolor", "gcolor2" },
   { "Meld", "meld" },
   { "Process manager", terminal .. "-e htop" },
   { "Music player", "deadbeef" }
}

mywebmenu = {
   { "Web-browser", "uzbl-tabbed" },
   { "IM", "pidgin" },
   { "Mutt", terminal .. " -e mutt" }
}

mybooksmenu = {}

mybooksmenu["IT/OS"] = {
   {'Linux', fm .. books .. '/IT/OS/Linux'},
   {'Windows', fm .. books .. '/IT/OS/Windows' }
}

mybooksmenu["IT/Programming"] = {
   {'Algorithms', fm .. books .. '/IT/Programming/Algorithms'},
   {'C', fm .. books .. '/IT/Programming/C'},
   {'Python', fm .. books ..'/IT/Programming/Python'},
   {'LISP and FP', fm .. books .. '/IT/Programming/LISP&FP'},
   {'Other', fm .. books .. '/IT/Programming/Other'}
}




mybooksmenu["IT"] = {
   { 'OS', mybooksmenu["IT/OS"]},
   {'Programming', mybooksmenu["IT/Programming"]},
   { 'LaTeX', fm .. books .. '/IT/LaTeX'  },
   { 'Net', fm .. books .. '/IT/Net'  },
   { 'Hardware', fm .. " " .. books .. '/IT/HW'  },
}


mybooksmenu["lang"] = {
   { 'all', fm .. books .. '/Lang'  },
}

mybooksmenu["favorite"] = {
   { 'all', fm .. books .. '/favorite'  },
}

mybooksmenu["belles-letters"] = {
   { 'all', fm .. books .. '/belles-lettres'  },
}


mybooksmenu["fantastic"] = {
   { 'all', fm .. books .. '/Fantastic'  },
}

mybooksmenu["SCI/Phisic"] = {
   { 'all', fm .. books .. '/SCI/Phisic'  },
}

mybooksmenu["SCI/Math"] = {
   { 'all', fm .. books .. '/Math'  },
}

mybooksmenu["SCI/ТРИЗ"] = {
   { 'all', fm .. books .. '/ТРИЗ'  },
}


mybooksmenu["SCI"] = {
   { 'Phisic', mybooksmenu["SCI/Phisic"]},
   { 'Math', mybooksmenu["SCI/Math"]},
   { 'Phisic', mybooksmenu["SCI/ТРИЗ"]},
}

mybooksmenu["BOOKS"] = {
   {'IT', mybooksmenu["IT"]},
   {'Lang', mybooksmenu["lang"]},
   {'SCI', mybooksmenu["SCI"]},
   {'Favorite', mybooksmenu["favorite"]},
   {'Belles-lettres', mybooksmenu["belles-letters"]},
   {'Fantastic', mybooksmenu["fantastic"]},
}


passed = mybooksmenu["BOOKS"]
function mybooksmenu() return passed end

myartmenu = {   
	{ "Tuxguitar", "tuxguitar" },
	{ "GIMP", "gimp" },
	{ "Openshot", "openshot" },
	{ "Art folder", fm .. home .. "/Art" }
}



mysystemmenu = {
   { "edit rc.lua", "gvim" .. home.. "/.config/awesome/rc.lua"  },
   { "emerge world", terminal .. " -e emerge -NDu world"  },
   { "restart awesome", awesome.restart },
   { "edit make.conf", "gvim /etc/make.conf" },
   { "Reboot", "sudo reboot" },
   { "Halt", "sudo halt" },
   { "Quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "games", mygamesmenu, beautiful.games_icon },
									{ "utils", myutilsmenu, beautiful.utils_icon },
									{ "web", mywebmenu, beautiful.web_icon },
									{ "books", mybooksmenu(), beautiful.books_icon },
									{ "system", mysystemmenu, beautiful.system_icon},
									{ "art", myartmenu, beautiful.art_icon},
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox

-- Create a systray
mysystray = widget({ type = "systray" })

-- Separator
separator =   widget({ type = "textbox" })
separator.text = "⁝⁝"

arrow1 =  widget({ type = "imagebox" })
arrow1.image = image(beautiful.arrow_icon)


arrow2 =  widget({ type = "imagebox" })
arrow2.image = image(beautiful.arrow2_icon)

-- Binary clock
binaryclock = {}
 binaryclock.widget = widget({type = "imagebox"})
 binaryclock.w = 51 --width 
 binaryclock.h = 24 --height (better to be a multiple of 6) 
 --dont forget that awesome resizes our image with clocks to fit wibox's height
 binaryclock.show_sec = true --must we show seconds? 
 binaryclock.color_active = beautiful.bg_focus --active dot color
 binaryclock.color_bg = beautiful.bg_normal --background color
 binaryclock.color_inactive = beautiful.fg_focus --inactive dot color
 binaryclock.dotsize = math.floor(binaryclock.h / 6) --dot size
 binaryclock.step = math.floor(binaryclock.dotsize / 2) --whitespace between dots
 binaryclock.widget.image = image.argb32(binaryclock.w, binaryclock.h, nil) --create image
 if (binaryclock.show_sec) then binaryclock.timeout = 1 else binaryclock.timeout = 20 end --we don't need to update often
 binaryclock.DEC_BIN = function(IN) --thanx to Lostgallifreyan (http://lua-users.org/lists/lua-l/2004-09/msg00054.html)
     local B,K,OUT,I,D=2,"01","",0
     while IN>0 do
         I=I+1
         IN,D=math.floor(IN/B),math.mod(IN,B)+1
         OUT=string.sub(K,D,D)..OUT
     end
     return OUT
 end
 binaryclock.paintdot = function(val,shift,limit) --paint number as dots with shift from left side
       local binval = binaryclock.DEC_BIN(val)
       local l = string.len(binval)
       local height = 0 --height adjustment, if you need to lift dots up
       if (l < limit) then
              for i=1,limit - l do binval = "0" .. binval end
       end
       for i=0,limit-1 do
              if (string.sub(binval,limit-i,limit-i) == "1") then
                    binaryclock.widget.image:draw_rectangle(shift,  binaryclock.h - binaryclock.dotsize - height, binaryclock.dotsize, binaryclock.dotsize, true, binaryclock.color_active)
              else
                    binaryclock.widget.image:draw_rectangle(shift,  binaryclock.h - binaryclock.dotsize - height, binaryclock.dotsize,binaryclock.dotsize, true, binaryclock.color_inactive)
              end
              height = height + binaryclock.dotsize + binaryclock.step
        end
 end
 binaryclock.drawclock = function () --get time and send digits to paintdot()
       binaryclock.widget.image:draw_rectangle(0, 0, binaryclock.w, binaryclock.h, true, binaryclock.color_bg) --fill background
       local t = os.date("*t")
       local hour = t.hour
       if (string.len(hour) == 1) then
              hour = "0" .. t.hour
       end
       local min = t.min
       if (string.len(min) == 1) then
              min = "0" .. t.min
       end
       local sec = t.sec
       if (string.len(sec) == 1) then
              sec = "0" .. t.sec
       end
       local col_count = 6
       if (not binaryclock.show_sec) then col_count = 4 end
       local step = math.floor((binaryclock.w - col_count * binaryclock.dotsize) / 8) --calc horizontal whitespace between cols
       binaryclock.paintdot(0 + string.sub(hour, 1, 1), step, 2)
       binaryclock.paintdot(0 + string.sub(hour, 2, 2), binaryclock.dotsize + 2 * step, 4)
       binaryclock.paintdot(0 + string.sub(min, 1, 1),binaryclock.dotsize * 2 + 4 * step, 3)
       binaryclock.paintdot(0 + string.sub(min, 2, 2),binaryclock.dotsize * 3 + 5 * step, 4)
       if (binaryclock.show_sec) then
              binaryclock.paintdot(0 + string.sub(sec, 1, 1), binaryclock.dotsize * 4 + 7 * step, 3)
              binaryclock.paintdot(0 + string.sub(sec, 2, 2), binaryclock.dotsize * 5 + 8 * step, 4)
       end
       binaryclock.widget.image = binaryclock.widget.image
   end
-- timer 
binarytimer = timer { timeout = binaryclock.timeout } --register timer
   binarytimer:add_signal("timeout", function()
       binaryclock.drawclock()
   end)
   binarytimer:start()

-- Vicious vidgets
mymemimg =  widget({ type = "imagebox" })
mymemimg.image = image(beautiful.mem_icon) 
memwidget =  widget({ type = "textbox" })
vicious.register(memwidget, vicious.widgets.mem, '<span background="#1E2320" font="ubuntu 12"> <span font="ubuntu 8"> $1% </span> </span>', 13)

mycpuimg =  widget({ type = "imagebox" })
mycpuimg.image = image(beautiful.cpu_icon)
cpuwidget =  widget({ type = "textbox" })
vicious.register(cpuwidget, vicious.widgets.cpu, '<span background="#1E2320" font="ubuntu 12"> <span font="ubuntu 8"> $1% </span> </span>', 3)

fswidgetimg =  widget({ type = "imagebox" })
fswidgetimg.image = image(beautiful.drive_icon)
fswidget =  widget({ type = "textbox" })
vicious.register(fswidget, vicious.widgets.fs, '<span background="#1E2320" font="ubuntu 12"> <span font="ubuntu 8">${/ avail_gb} · ${/home avail_gb} </span> </span>', 8)

netwidget =  widget({ type = "textbox" })
vicious.register(netwidget, vicious.widgets.net, '<span background="#1E2320" font="ubuntu 12"> <span font="ubuntu 8">D: ${eth0 down_kb} U:${eth0 up_kb} </span> </span>', 3 )

-- gmail widget and tooltip
mygmail =  widget({ type = "textbox" })
gmail_t = awful.tooltip({ objects = { mygmail },})

mygmailimg =  widget({ type = "imagebox" })
mygmailimg.image = image(beautiful.gmail_icon)

vicious.register(mygmail, vicious.widgets.gmail,
                function (widget, args)
                    gmail_t:set_text(args["{subject}"])
                    gmail_t:add_to_object(mygmailimg)
                    return "  " .. args["{count}"] .. "  "
                 end, 300) 

-- Weather widget
weatherimg =  widget({ type = "imagebox" })
weatherimg.image = image(beautiful.weather_icon)

weatherwidget =  widget({ type = "textbox" })
weather_t = awful.tooltip({ objects = { weatherwidget },})

vicious.register(weatherwidget, vicious.widgets.weather,
                function (widget, args)
                    weather_t:set_text("City: " .. args["{city}"] .."\nWind: " .. args["{windkmh}"] .. "km/h " .. args["{wind}"] .. "\nSky: " .. args["{sky}"] .. "\nHumidity: " .. args["{humid}"] .. "%")
                    return  args["{tempc}"] .. '<span color="white"><b> °C </b></span>'
                end, 1800, "UKCW")
                --'1800': check every 30 minutes.
                --'UKCW': the Lugans'k ICAO code.


-- Keyboard layout widget

-- {{{ Keyboard layout widgets



kbd_dbus_sw_cmd = "dbus-send --dest=ru.gentoo.KbddService /ru/gentoo/KbddService ru.gentoo.kbdd.set_layout uint32:"
kbd_dbus_prev_cmd = "dbus-send --dest=ru.gentoo.KbddService /ru/gentoo/KbddService ru.gentoo.kbdd.prev_layout"
kbd_dbus_next_cmd = "dbus-send --dest=ru.gentoo.KbddService /ru/gentoo/KbddService ru.gentoo.kbdd.next_layout"

kbdmenu =awful.menu({ items = {  { "English", kbd_dbus_sw_cmd .. "0"},
        { "Русский", kbd_dbus_sw_cmd .. "1" },
        }
})

kbdwidget =  widget({ type = "textbox", name = "kdbwidget" })
kbdwidget.align="center"
kbdwidget.text = "<b>Eng</b>"
kbdwidget.bg_align = "center"
kbdwidget.bg_resize = true
awful.widget.layout.margins[kbdwidget] = { left = 0, right = 10 }
kbdwidget:buttons(awful.util.table.join(
        awful.button({ }, 1, function() os.execute(kbd_dbus_prev_cmd) end),
        awful.button({ }, 2, function() os.execute(kbd_dbus_next_cmd) end),
        awful.button({ }, 3, function() kbdmenu:toggle () end)
))


dbus.request_name("session", "ru.gentoo.kbdd")
dbus.add_match("session", "interface='ru.gentoo.kbdd',member='layoutChanged'")
dbus.add_signal("ru.gentoo.kbdd", function(...)
        local data = {...}
        local layout = data[2]
        lts = {[0] = "Eng", [1] = "Ru"}
        kbdwidget.text = "<b>"..lts[layout].."</b>"
        end)



--DeadBeef nowplaying widget
ddbimg =  widget({ type = "imagebox" })
ddbimg.image = image(beautiful.sound_icon)
     ddbwidget =  widget({ type = "textbox" })
     function ddbnow()
         local ddb = io.popen('  deadbeef --nowplaying  \"  %a - %t   %e/%l \"  ', "r")
         local current = ddb:read()
         return current
     end
     ddbtimer = timer({ timeout = 1 })
     ddbtimer:add_signal("timeout", function() 
	 ddbwidget.text = ddbnow() end)
     ddbtimer:start()
-- Last emerge sync widget
lastsyncimg =  widget({ type = "imagebox" })
lastsyncimg.image = image(beautiful.sync_icon)

local sync = {
	["{weekday}"] = "N/A",
	["{date}"]    = "N/A",
	["{month}"]   = "N/A",
	["{year}"]    = "N/A",
	["{hour}"]    = "N/A",
	["{minutes}"] = "N/A"
}
local function timestamp()
	local l = {}
	local f = io.open("/usr/portage/metadata/timestamp.chk", "r")
	local t = f:read("*line")
	f:close()
	for w in t:gmatch("%w+") do 
	table.insert(l,w) 
	end
	sync["{weekday}"], sync["{date}"], sync["{month}"], sync["{year}"], sync["{hour}"], sync["{minutes}"] = l[1], l[2], l[3], l[4], l[5], l[6], l[7]
	return sync
end

	lastsyncwidget =  widget({ type = "textbox" })
	lastsyncwidget.text = sync["{date}"] .. " " .. sync["{month}"]
	timestamptimer = timer({ timeout = 30 })
	timestamptimer:add_signal("timeout", function() 
	timestamp() 
	lastsyncwidget.text = sync["{date}"] .. " " .. sync["{month}"]
	end)
	timestamptimer:start()

-- Create a wibox for each screen and add it
mywibox = {}
htopwibox = {}
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
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
	    binaryclock.widget,
        s == 1 and mysystray or nil,
		kbdwidget,
		ddbwidget, ddbimg,
		arrow2, netwidget, arrow1,
		weatherwidget, weatherimg,
		arrow2, fswidget,fswidgetimg,arrow1, 
		lastsyncwidget, lastsyncimg,
		arrow2,cpuwidget,mycpuimg, arrow1,
		mygmail,mygmailimg,
		arrow2, memwidget,mymemimg,arrow1,
		separator,
        mytasklist[s],
		separator,
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
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

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

	awful.key({ }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/ 2>/dev/null'") end),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

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
					 size_hints_honor = false,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },

	{ rule = { class = "Pidgin" },
      properties = { tag = tags[1][5] } },
	{ rule = { class = "xpad" },
      properties = { floating = true } },
	{ rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

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

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}





-- Autostart
--
autostart_dir = awful.util.getdir("config") .. "/autostart"
function autostart(dir)
    if not dir then
        do return nil end
    end
    local fd = io.popen("ls -1 -F " .. dir)
    if not fd then
        do return nil end
    end
    for file in fd:lines() do
        local c= string.sub(file,-1)   -- last char
        executable = string.sub( file, 1,-2 )
        print("Awesome Autostart: Executing: " .. executable)
        os.execute(dir .. "/" .. executable .. " &") -- launch in bg
    end
    io.close(fd)
end
autostart(autostart_dir)
-- 
