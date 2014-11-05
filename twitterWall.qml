/**
  * @author Jozef Mlich <xmlich02@stud.fit.vutbr.cz>
  * @licence LGPL
  */

import QtQuick 2.0
//import QtQuick.XmlListModel 2.0
import "OAuth.js" as OAuthLogic

Rectangle {
    id: window
    color: "#f5f5f4"

    property string searchPhrase: 'openalt'
    property variant sessions;

    width: 1024
    height: 768

    Image {
        id: logoImage
        anchors.top: parent.top
        anchors.left: listView.right
        anchors.right: parent.right
        anchors.margins: 30;
        source: "images/logo-openalt-conference.svg"

        fillMode: Image.PreserveAspectFit
//        height: parent.width/1144*141
    }

    ListView {
        clip: true
        id: listView
        anchors.left: parent.left
        width: parent.width*0.7
        anchors.top: parent.top;
        anchors.bottom: partnersRect.top;
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

    ListView {
        clip: true
        anchors.left: listView.right
        anchors.right: parent.right
        anchors.top: logoImage.bottom
        anchors.bottom: parent.bottom
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        spacing: 3;

        model:  currentEvents;
        delegate: ScheduleDelegate {
            startTime: parseInt(model.event_start, 10);
            endTime: parseInt(model.event_end, 10);
            roomShort: model.room_short;
            roomColor:  model.room_color;
            room: model.room;
            speakers_str: model.speakers_str;
            topic: model.topic
        }


    }

    Rectangle {
        id: partnersRect
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 40;

        color: "#ffffff";
        ListView {
            spacing: 30;
            anchors.fill: parent;
            anchors.margins: 5;
            orientation: ListView.Horizontal ;
            model: partneriModel
            delegate: Image {
                anchors.margins: 5;
                anchors.verticalCenter: parent.verticalCenter
                source: model.img;
                fillMode: Image.PreserveAspectFit;
                width: (status !== Image.Ready) ? 0 : sourceSize.width;
                Behavior on width {
                    NumberAnimation {
                        duration: 500;
                    }
                }
            }
        }

    }



    Timer {
        interval: 15000
        repeat: true;
        running: true;
        onTriggered: {
            if (listView.currentIndex < listView.count) {
                listView.incrementCurrentIndex()
            }

        }
    }

    Timer {
        //        interval: 30000
        interval: 60000
        repeat: true;
        running: true;
        //        running: false;
        onTriggered: {
            download()



            //            if (listView.currentIndex+1 == listModel.count) {
            //                listView.positionViewAtBeginning();
            //            } else {
            //                listView.incrementCurrentIndex();
            //            }
        }
    }



    ListModel {
        id: partneriModel;
    }

    ListModel {
        id: listModel
    }

    ListModel {
        id: currentEvents
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
        download_schedule()
        download_partneri();
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
        params.push(["count", "100"])

        var http = OAuthLogic.createOAuthHeader("GET", url, undefined, {"token":oauth.token, "secret":oauth.secret}, params);

        //count=100&include_entities=true&q=%23' + searchPhrase

        http.onreadystatechange = function(){
            if (http.readyState === XMLHttpRequest.DONE) {
                //                        console.log('download STEP\n' +url + "\n" +http.status+'\n'+http.getAllResponseHeaders()+'\n'+http.responseText+http.responseXML);
                //                        console.log(http.responseText);

                if (http.status === 200) {
                    var remote = JSON.parse(http.responseText)
                    //                            console.log(remote)
                    //                            listModel.clear();
                    for (var i = remote.statuses.length-1; i >= 0; i--) {
                        //console.log(remote[i].text)
                        //if (listModel.
                        //                                console.log(JSON.stringify(remote.statuses[i]))
                        //                                break;
                        var found = false;
                        for (var j = 0; j < listModel.count; j++) {
                            var obj = listModel.get(j);
                            if (obj.id_str === remote.statuses[i].id_str) {
                                found = true;
                            }

                        }
                        if (!found) {
                            listModel.append(remote.statuses[i])

                        }

                        // listModel.insert(0, remote.statuses[i]);
                    }

                    //                            for (var i = 0; i < remote.results.length; i++) {
                    //                                listModel.append(remote.results[i])
                    //                            }
                    //console.log(listModel.count)

                } else { // offline or error while downloading

                    console.log("download() error " + http.status )


                }

            }
        }

        http.send()

    }

    function download_schedule() {
        console.log("data download")

        var url = "http://pcmlich.fit.vutbr.cz/openalt/?json=1&lang=cs_CZ";

        var http = new XMLHttpRequest()
        http.open("GET", url, true)

        http.onreadystatechange = function(){
            if (http.readyState == 4) {
                if (http.status == 200) {

                    var data = JSON.parse(http.responseText);
                    sessions = data.sessions;

                    updateCurrentEvents();

                } else { // offline or error while downloading
                    console.log("error downloading ")
                }
            }
        }
        http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;");
        //http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Connection", "close");
        //        http.send(params)
        http.send()

    }

    function download_partneri() {

        var url = "http://pcmlich.fit.vutbr.cz/openalt_web/partneri_api.php";

        var http = new XMLHttpRequest()
        http.open("GET", url, true)

        http.onreadystatechange = function(){
            if (http.readyState == 4) {
                if (http.status == 200) {

                    var data = JSON.parse(http.responseText);
                    partneriModel.clear();
                    for (var i = 0; i < data.length; i++) {
                        partneriModel.append(data[i]);
                    }

                } else { // offline or error while downloading
                    console.log("error downloading ")
                }
            }
        }
        http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;");
        //http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Connection", "close");
        //        http.send(params)
        http.send()

    }

    function updateCurrentEvents() {
        if (sessions === undefined) {
            return;
        }

        var now = Math.floor(new Date().getTime()/1000);


        currentEvents.clear();
        var j = 0;
        for (var i = 0; i < sessions.length; i++) {
            var item = sessions[i];
            if (item.event_end > now) {
                item.speakers_str = make_speakers_str(item.speakers);
                item.speakers = JSON.stringify(item.speakers)
                item.event_start = parseInt(item.event_start, 10);
                item.event_end = parseInt(item.event_end, 10);
                currentEvents.append(item)
//                j++;
            }
//            if (j >= 10) { // FIXME: CURRENT_EVENTS COUNT ON FIRST PAGE
//                break;
//            }
        }

    }

    function make_speakers_str(speakersArray ) {
        var str = "";
        for (var j = 0; j < speakersArray.length; j++) {
            str += speakersArray[j];
            if ((speakersArray.length-1) != j) {
                str += ", ";
            }
        }
        return str;

    }



    Timer {
        running: true;
        repeat: true;
        onTriggered: {
            updateCurrentEvents();
            download_partneri();
        }
        interval: 300000; // 5 minutes
    }

}

