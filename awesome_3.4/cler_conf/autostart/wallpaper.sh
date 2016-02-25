#!/bin/bash
while true;
do
 	awsetbg -r .config/awesome/themes/zen/wallpapers/ 
	sleep $[ ( $RANDOM % 1800 )  + 600 ]s
done &
