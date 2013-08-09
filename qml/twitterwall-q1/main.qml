import QtQuick 1.0
//import QtQuick.XmlListModel 2.0
import "OAuth.js" as OAuthLogic

Rectangle {
    id: window
    color: "#f5f5f4"

    property string searchPhrase: 'guadec'

    width: 1024
    height: 768

//    NiceBackground {
//        anchors.fill: parent;
//        z: -1000

//    }

    Image {
        id: logoImage
        anchors.top: parent.top
        anchors.margins: 20
        anchors.horizontalCenter: parent.horizontalCenter

        source: "images/logo.png"
    }

    Image {
        id: skylineImage
        source: "images/skyline.png"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        z:1
    }


    ListView {
        clip: true
        id: listView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: logoImage.bottom
        anchors.bottom: skylineImage.top
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        anchors.topMargin: 10
        anchors.bottomMargin: 10

        model:  listModel;
        delegate: MessageBox {
            status_text: model.text
//            user_name: model.from_user
                        user_name: model.user.screen_name
//            profile_picture: model.profile_image_url
            profile_picture: model.user.profile_image_url_https
            bigImage: (model.entities.media !== undefined) ? model.entities.media[0].media_url : ""


        }
        spacing: 20


    }


    Timer {
        interval: 30000
        repeat: true;
        running: true;
//        running: false;
        onTriggered: {
            if (listView.currentIndex+1 == listModel.count) {
                listView.positionViewAtBeginning();
                download()
            } else {
                listView.incrementCurrentIndex();
            }
        }
    }




    ListModel {
        id: listModel
    }

    ConfigFile {
        id: configfile
    }


    OAuth {
        id: oauth
        onAuthenticationCompleted: download()
        onSecretChanged: configfile.set("secret", secret)
        onTokenChanged: configfile.set("token", token)
    }

    Component.onCompleted: {
        oauth.token = configfile.get("token")
        oauth.secret = configfile.get("secret")
        oauth.beginAuthentication()
    }



    function download() {

        if (!oauth.authorized) {
            oauth.beginAuthentication();
            return;
        }

//        var url = "https://api.twitter.com/1.1/statuses/home_timeline.json"

        var url = 'https://api.twitter.com/1.1/search/tweets.json'
        var params = new Array();
        params.push(["q", "%23"+searchPhrase])
        params.push(["include_entities", "true"])
        params.push(["count", "25"])

        var http = OAuthLogic.createOAuthHeader("GET", url, undefined, {"token":oauth.token, "secret":oauth.secret}, params);

        //count=100&include_entities=true&q=%23' + searchPhrase

        http.onreadystatechange = function(){
                    if (http.readyState === XMLHttpRequest.DONE) {
//                        console.log('download STEP\n' +url + "\n" +http.status+'\n'+http.getAllResponseHeaders()+'\n'+http.responseText+http.responseXML);

                        if (http.status === 200) {
                            var remote = JSON.parse(http.responseText)
//                            console.log(remote)
                            listModel.clear();
                            for (var i = 0; i < remote.statuses.length; i++) {
                                //console.log(remote[i].text)
                                listModel.append(remote.statuses[i])
                            }

//                            for (var i = 0; i < remote.results.length; i++) {
//                                listModel.append(remote.results[i])
//                            }

                        } else { // offline or error while downloading

                            console.log("download() error " + http.status )


                        }

                    }
                }

        http.send()

    }


}

