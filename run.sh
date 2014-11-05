#!/bin/sh

gsettings set org.gnome.desktop.lockdown disable-lock-screen 'false'
xset -dpms
xset dpms off
xset s noblank
xset s off
xset dpms force off

killall gnome-screensaver
killall mate-screensaver
killall xscreensaver

# ~/Qt5.0.2/5.0.2/gcc/bin/qmlscene ./twitterWall.qml 
#~/Qt5.1/5.1.0/gcc_64/bin/qmlscene --fullscreen ./twitterWall.qml 
qmlscene --fullscreen ./twitterWall.qml

#~/Qt/5.1.1/gcc/bin/qmlscene ./twitterWall.qml 
