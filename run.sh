#!/bin/sh

xset -dpms
xset dpms off
xset s noblank
xset s off
xset dpms force off

#~/Qt5.0.2/5.0.2/gcc/bin/qmlscene ./twitterWall.qml 
#killall gnome-screensaver
#killall mate-screensaver
#killall xscreensaver
~/Qt5.0.2/5.0.2/gcc/bin/qmlscene --fullscreen ./twitterWall.qml 
