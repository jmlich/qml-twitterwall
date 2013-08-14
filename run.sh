#!/bin/sh
# @author Jozef Mlich <xmlich02@stud.fit.vutbr.cz>
# @licence LGPL

## disable screensaver

#killall gnome-screensaver
#killall mate-screensaver
#killall xscreensaver

## disable power saving

#xset -dpms
#xset dpms off
#xset s noblank
#xset s off
#xset dpms force off


#~/Qt5.0.0/5.0.0/gcc/bin/qmlscene --fullscreen ./twitterWall.qml 
~/Qt5.0.1/5.0.1/gcc/bin/qmlscene --fullscreen ./twitterWall.qml 
#~/Qt5.0.1/5.0.1/gcc/bin/qmlscene ./twitterWall.qml 
