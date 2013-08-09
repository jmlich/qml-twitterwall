import QtQuick 1.0

Rectangle {
    id: stateExampleRect
    width: parent.width
    height: (bigImageContainer.status === Image.Ready) ? 420 : 100
    color: "#6b8e9f"
    transformOrigin: Item.BottomLeft
    radius: 10

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
        width: 60
        height: 60;
        source: profile_picture
    }

    Image {
        height: 300
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

}
