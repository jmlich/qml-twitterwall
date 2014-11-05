/**
  * @author Jozef Mlich <xmlich02@stud.fit.vutbr.cz>
  * @licence LGPL
  */

import QtQuick 2.0
import "Theme.js" as Theme

Rectangle {

           id: scheduleDelegate
           height: Math.max(startTimeLabel.height + endTimeLabel.height + roomNameLabel.height + 2* Theme.paddingSmall, roomLabel.height, topicLabel.height) + 2 * Theme.paddingSmall

           property var startTime;
           property var endTime;
           property alias roomShort: roomLabel.text;
           property alias roomColor: roomLabel.color;
           property alias room: roomNameLabel.text;
           property string speakers_str;
           property string topic;
           anchors.left: parent.left;
           anchors.right: parent.right;

           color: Theme.background_color
           border.color: "#cccccc";
           border.width: 1;

           Text {
               id: startTimeLabel
               text: format_time(startTime);
               font.pixelSize: Theme.tertiary_pixelSize;
               color: scheduleDelegate.highlighted ? Theme.secondary_color_highlight : Theme.secondary_color
               anchors.left: parent.left;
               anchors.top: parent.top;
               anchors.margins: Theme.paddingSmall

           }
           Text {
               id: endTimeLabel
               text: format_time(endTime);
               font.pixelSize: Theme.tertiary_pixelSize;
               color: scheduleDelegate.highlighted ? Theme.secondary_color_highlight : Theme.secondary_color
               anchors.left: parent.left;
               anchors.top: startTimeLabel.bottom
               anchors.margins: Theme.paddingSmall

           }
           Text {
               id: roomNameLabel;
               anchors.left: parent.left;
               anchors.top: endTimeLabel.bottom
               anchors.margins: Theme.paddingSmall
           }

           Text {
               id: roomLabel
               anchors.left: startTimeLabel.right
               anchors.top: parent.top;
               anchors.margins: Theme.paddingMedium
               font.pixelSize: Theme.primary_pixelSize
               color: Theme.primary_color
//               font.family: Theme.fontFamilyHeading
               font.weight: Font.Bold
           }


           Text {
               id: topicLabel
               anchors.left: roomLabel.right
               anchors.right: parent.right
               anchors.top: parent.top;
               anchors.margins: Theme.paddingMedium
               font.pixelSize: Theme.secondary_pixelSize

               text: (speakers_str !== "") ? (speakers_str + ": " + topic) : topic
               color: scheduleDelegate.highlighted ? Theme.primary_color_highlight : Theme.primary_color;

               wrapMode: Text.Wrap;
               textFormat: Text.PlainText

           }

           function format_time(unix_timestamp) {
           var date = new Date(unix_timestamp*1000);
               var hours = date.getHours();
               var minutes = date.getMinutes();
               return pad2(hours)+":"+pad2(minutes)
           }
           function pad2(i) {
               if (i > 9) {
                   return i
               }
               return "0"+i
           }


}


