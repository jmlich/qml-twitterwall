import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: demoMain;

    property bool useDropShadow: true;
    property bool useSwirls: true;
    property bool useSimpleGradient: false;

    Rectangle {
        id: gradientBox
        anchors.fill: parent;
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0.64 * 0.6, 0.82 * 0.6, 0.15 * 0.6) }
            GradientStop { position: 1.0; color: "black" }
        }
    }



    Rectangle {
        id: colorTable
        width: 1
        height: 46
        color: "transparent"

        Column {
            spacing: 2
            y: 1
            Rectangle { width: 1; height: 10; color: "white" }
            Rectangle { width: 1; height: 10; color: Qt.rgba(0.64 * 1.4, 0.82 * 1.4, 0.15 * 1.4, 1); }
            Rectangle { width: 1; height: 10; color: Qt.rgba(0.64, 0.82, 0.15); }
            Rectangle { width: 1; height: 10; color: Qt.rgba(0.64 * 0.7, 0.82 * 0.7, 0.15 * 0.7); }
        }

        layer.enabled: true
        layer.smooth: true
        visible: false;
    }



    Swirl
    {
        x: 0;
        width: parent.width
        height: parent.height * 0.2
        anchors.bottom: parent.bottom;
        amplitude: height * 0.2;
        colorTable: colorTable;
        speed: 0.2;
        opacity: 0.3
        visible: parent.useSwirls;
    }

}
