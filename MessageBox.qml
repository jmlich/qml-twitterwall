/**
  * @author Jozef Mlich <xmlich02@stud.fit.vutbr.cz>
  * @licence LGPL
  */

import QtQuick 2.0

Rectangle {
    id: messageBoxRect
    anchors.horizontalCenter: parent.horizontalCenter

    width: parent.width
    height: (bigImageContainer.status === Image.Ready) ? 440 : 120
    color: "#66204a87"
//    color: "#00ffffff"


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
        color: "#ffffff"
        text: "<style type='text/css'>a:link{color:#FFFF00} a:visited{color:#00FFFF}</style> <b>@" +  user_name + "</b>: " + replaceURLWithHTMLLinks(status_text)
        textFormat: Text.RichText
        onLinkActivated: { Qt.openUrlExternally(link); }
    }
    Image {
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.margins: 20
        width: 80
        height: 80;
        source: profile_picture
    }

    Image {
        height: messageBoxRect.height - 140 // 300
        id: bigImageContainer
        anchors.left: tweetText.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 20
        fillMode: Image.PreserveAspectFit
    }

    function replaceURLWithHTMLLinks(text) {
        var exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/i;
        return text.replace(exp,"<a href='$1'>$1</a>");
    }


    Behavior on height {
        NumberAnimation { duration: 100; }
    }


//    transformOrigin: Item.Center;
//    scale: 0

//    NumberAnimation {
//        id: scaleAnimation
//        target: messageBoxRect
//        property: "scale"
//        to: 1.0;
//        duration: 800;
//        easing.type: Easing.OutElastic
//    }

//    Component.onCompleted: {
//        scaleAnimation.start()
//    }

}
