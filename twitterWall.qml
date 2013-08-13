/**
  * @author Jozef Mlich <xmlich02@stud.fit.vutbr.cz>
  * @licence LGPL
  */
import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import "OAuth.js" as OAuthLogic

Rectangle {
    id: window
    color: "#00ffffff"

    property string searchPhrase: 'foto'

    width: 800
    height: 600

    NiceBackground {
        anchors.fill: parent;
        z: -1000

    }


    ListView {
        id: listView
        anchors.fill: parent;
        anchors.margins: 20
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
                download()
            } else {
                listView.incrementCurrentIndex();
            }
        }
    }

    Image {
        id: busyIndicator
        anchors.centerIn: parent;
        source: "./images/progress.png"
        visible: (listModel.count == 0) && (!oauth.pinVisible)
        transformOrigin: Item.Center
        RotationAnimation {
            target: busyIndicator
            property: "rotation" // Suppress a warning
            from: 0
            to: 360
            direction: RotationAnimation.Clockwise
            duration: 2000
            loops: Animation.Infinite
            running: true
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
        params.push(["count", "50"])

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
                            if (http.status === 401) {
                                oauth.secret = "";
                                oauth.token = "";
                                oauth.authorized = false;
                                download()
                                console.log("authentication failed")
                            } else {
                                console.log("download() error " + http.status )
                                download();
                            }


                        }

                    }
                }

        http.send()

    }


}

