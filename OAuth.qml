/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the QtDeclarative module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** No Commercial Usage
** This file contains pre-release code and may not be distributed.
** You may use this file in accordance with the terms and conditions
** contained in the Technology Preview License Agreement accompanying
** this package.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights.  These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
**
**
**
**
**
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtWebKit 3.0
import "OAuth.js" as OAuthLogic

Item{
    id: root
    width: 1024
    height: 768
    property string token;
    property string secret;
    function beginAuthentication(){
        if (token !== "" && secret !== "") {
            authorized = "";
            console.log("already authorized")
            authorized = true;
            authenticationCompleted();
            return;
        }

        step = 1;
        stepOne();
    }
    signal authenticationCompleted;

    property int step: 0
    function nextStep(){
        switch(step) {
        case 1: stepOne(); break;
        case 2: stepTwo(); break;
        case 3: stepThree(); break;
        }
    }
    function stepOne(){
        var xhr = OAuthLogic.createOAuthHeader("POST", "https://api.twitter.com/oauth/request_token", [["oauth_callback","oob"]]);
        console.log("zacinam")
        xhr.onreadystatechange = function() { 
            if (xhr.readyState === XMLHttpRequest.DONE) {
                console.log("step one")
//                console.log(xhr.status+'\n'+xhr.getAllResponseHeaders()+'\n'+xhr.responseText+xhr.responseXML);
                var response = xhr.responseText.split('&');
                if(response.length !== 3)
                    return;
                token = response[0].split('=')[1];
                secret = response[1].split('=')[1];
                if(response[2].split('=')[1] !== 'true')
                    console.log("Error: " + response[2]);
                step = 2;
                Qt.openUrlExternally("https://api.twitter.com/oauth/authorize?oauth_token="+token);
            }
        }
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.setRequestHeader("Accept-Language", "en");
        xhr.send();
    }

    function stepTwo() {
        console.log("step two, waiting for web browser")
    }


    function stepThree(){
        var pin = pinTextInput.text //webItem.evaluateJavaScript("document.getElementById(\"oauth_pin\").innerHTML;").replace(/[ \n]*/g, "");
        var xhr = OAuthLogic.createOAuthHeader("POST", "https://api.twitter.com/oauth/access_token", [["oauth_verifier",pin]], {"token":token,"secret":secret});
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
//                console.log('STEP 3\n'+xhr.status+'\n'+xhr.getAllResponseHeaders()+'\n'+xhr.responseText+xhr.responseXML);
                var response = xhr.responseText.split('&');
                if(response.length !== 4)
                    return;
                token = response[0].split('=')[1];
                secret = response[1].split('=')[1];
                //username = respones[3].split('=')[1];
                step = 0;
                authorized = true;
                authenticationCompleted();
            }
        }
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.setRequestHeader("Accept-Language", "en");
        xhr.send();
    }
    property bool authorized: false

    Rectangle {
        color: "white"
        anchors.left: parent.left;
        anchors.top: parent.top;

        width: 300;
        height: 30;
        Text {
            text: "pin"
            anchors.verticalCenter: parent.verticalCenter;
            anchors.left: parent.left
            font.pixelSize: 30
        }

        TextInput {
            z: 10
            id: pinTextInput
            anchors.leftMargin: 100
            anchors.fill: parent;
            font.pixelSize: 30
            focus: true
            onAccepted: {
                step = 3;
                nextStep();
            }
        }

        visible: step === 2

    }

}
