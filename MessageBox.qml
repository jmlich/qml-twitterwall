/**
  * @author Jozef Mlich <xmlich02@stud.fit.vutbr.cz>
  * @licence LGPL
  */

import QtQuick 2.0

Rectangle {
    id: stateExampleRect
    width: parent.width
    height: Math.max(tweetText.paintedHeight + 2* tweetText.anchors.margins, tweetAvatar.paintedHeight + tweetAvatar.anchors.margins ) + bigImageContainer.height + bigImageContainer.anchors.margins
//    color: "#6b8e9f"
    border.color: "#bdbdbd";
    border.width: 1
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#ebebeb" }
        GradientStop { position: 1.0; color: "#c6c6c6" }
    }
    transformOrigin: Item.BottomLeft
//    radius: 10

    property string status_text
    property string user_name
    property string profile_picture
    property alias bigImage: bigImageContainer.source
    clip: true


    Text {
        id: tweetText
        anchors.fill: parent;
        anchors.margins: 20
        anchors.leftMargin: 120
        wrapMode: Text.Wrap
        font.pixelSize: 20
        color: "#000000"
//        text: "<style type='text/css'>a:link{color:#FFFF00} a:visited{color:#00FFFF}</style> <b>@" +  user_name + "</b>: " + replaceURLWithHTMLLinks(status_text)
        text: "<b>@" +  user_name + "</b>: " + replaceURLWithHTMLLinks(status_text)
        textFormat: Text.RichText
        onLinkActivated: { Qt.openUrlExternally(link); }
    }
    Image {
        id: tweetAvatar
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.margins: 20
        width: 60
        height: 60;
        source: profile_picture
    }

    Image {
        height: (status !== Image.Ready) ? 0 : 300
        id: bigImageContainer
        anchors.left: tweetText.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 20
        fillMode: Image.PreserveAspectFit

//        Behavior on height {
//            NumberAnimation {
//                duration: 500;
//            }
//        }

    }

    function replaceURLWithHTMLLinks(text) {
        var exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/i;
        return text.replace(exp,"<a href='$1'>$1</a>");
    }

}
