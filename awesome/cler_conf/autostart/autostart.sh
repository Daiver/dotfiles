#! /bin/bash

# until [[ "x$i" == "x1" ]]; do
#       cairo-compmgr && i=1
# done

run_once() {
	pgrep -f -u "${USER}" -x "$1" &> /dev/null || $@
}

run_once kbdd
run_once setxkbmap -layout us,ru -variant ,winkeys grp:caps_toggle compose:ralt
run_once parcellite
