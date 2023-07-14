import QtQuick 2.7
import QtQuick.Controls 2.2
import com.seame.Speed 1.0
import com.seame.Buttons 1.0
import com.seame.RPM 1.0

ApplicationWindow {
    visible: true
    width: 1280
    height: 960
    title: qsTr("Controller")

    property string clickedButton: "P"

    Speed {
        id: speed
    }

    Buttons {
        id: buttons
    }

    RPM {
        id: rpm
    }

    Slider {
        id: speedBar
        width: 631
        height: 219
        rotation: 270
        anchors.verticalCenterOffset: -26
        anchors.horizontalCenterOffset: -236
        from: 0
        to: 260
        value: 0

        onValueChanged: {
            speed.adjustSpeed(speedBar.value);
        }

        anchors.centerIn: parent
    }

    Slider {
        id: rpmBar
        width: 631
        height: 219
        rotation: 270
        anchors.verticalCenterOffset: -26
        anchors.horizontalCenterOffset: 231
        from: 0
        to: 8000
        value: 0

        onValueChanged: {
            rpm.adjustRPM(rpmBar.value);
        }

        anchors.centerIn: parent
    }



    Column {
        id: orderButtons
        anchors.centerIn: parent
        spacing: 10

        Button {
            id: buttonP
            text: "P"
            onClicked: {
                buttons.adjustButtons("P");
                clickedButton = "P";
            }
            width: 100
            height: 100
            font.pixelSize: 40
            font.bold: true
            background: Rectangle {
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "black" }
                    GradientStop { position: 1.0; color: "gray" }
                }
            }
            contentItem: Text {
                text: buttonP.text
                color: clickedButton === "P" ? "red" : "white"
                font.pointSize: 40
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Button {
            id: buttonR
            text: "R"
            onClicked: {
                buttons.adjustButtons("R");
                clickedButton = "R";
            }
            width: 100
            height: 100
            font.pixelSize: 40
            font.bold: true
            background: Rectangle {
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "black" }
                    GradientStop { position: 1.0; color: "gray" }
                }
            }
            contentItem: Text {
                text: buttonR.text
                color: clickedButton === "R" ? "red" : "white"
                font.pointSize: 40
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Button {
            id: buttonN
            text: "N"
            onClicked: {
                buttons.adjustButtons("N");
                clickedButton = "N";
            }
            width: 100
            height: 100
            font.pixelSize: 40
            font.bold: true
            background: Rectangle {
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "black" }
                    GradientStop { position: 1.0; color: "gray" }
                }
            }
            contentItem: Text {
                text: buttonN.text
                color: clickedButton === "N" ? "red" : "white"
                font.bold: true
                font.pointSize: 40
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Button {
            id: buttonD
            text: "D"
            onClicked: {
                buttons.adjustButtons("D");
                clickedButton = "D";
            }
            width: 100
            height: 100
            font.pixelSize: 40
            font.bold: true
            background: Rectangle {
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "black" }
                    GradientStop { position: 1.0; color: "gray" }
                }
            }
            contentItem: Text {
                text: buttonD.text
                color: clickedButton === "D" ? "red" : "white"
                font.bold: true
                font.pointSize: 40
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
//        Button {
//            id: buttonJ
//            text: "J"
//            onClicked: {
//                buttons.adjustButtons("J");
//                clickedButton = "J";
//            }
//            width: 100
//            height: 100
//            font.pixelSize: 40
//            font.bold: true
//            background: Rectangle {
//                gradient: Gradient {
//                    GradientStop { position: 0.0; color: "black" }
//                    GradientStop { position: 1.0; color: "gray" }
//                }
//            }
//            contentItem: Text {
//                text: buttonJ.text
//                color: clickedButton === "J" ? "red" : "white"
//                font.bold: true
//                font.pointSize: 40
//                horizontalAlignment: Text.AlignHCenter
//                verticalAlignment: Text.AlignVCenter
//            }
//        }
    }
//    Button {
//        id: buttonWeather
//        property bool isToggled: false
//        x: 354
//        y: 826 // Add this line

//        onClicked: {
//            buttons.adjustButtons("Weather");
//            isToggled = !isToggled; // This line toggles the state
//        }
//        width: 100
//        height: 100

//        contentItem: Image {
//            id: weatherImage
//            width: 100
//            height: 100
//            source: buttonWeather.isToggled ? "image/weather1.png" : "image/weather.png" // Use the state here
//        }

//        background: Rectangle {
//            color: "transparent"
//        }
//    }
    Button {
            id: buttonstart
            property bool isToggled: false
            x: 830
            y: 70 // Add this line

            onClicked: {
                buttons.adjustButtons("Start");
                isToggled = !isToggled; // This line toggles the state
            }
            width: 200
            height: 120

            contentItem: Image {
                id: startImage
                width: 100
                height: 100
                source: buttonstart.isToggled ? "image/start_on.png": "image/soff.png"  // Use the state here
            }

            background: Rectangle {
                color: "transparent"
            }
        }
    Button {
        id: buttonWarn
        property bool isToggled: false
        x: 870
        y: 860 // Add this line

        onClicked: {
            buttons.adjustButtons("Warn");
            isToggled = !isToggled; // This line toggles the state
        }
        width: 100
        height: 100

        contentItem: Image {
            id: warnImage
            width: 100
            height: 100
            source: buttonWarn.isToggled ? "image/warn.png" : "image/warn1.png" // Use the state here
        }

        background: Rectangle {
            color: "transparent"
        }
    }
    Button {
        id: buttonLeft
        property bool isToggled: false
        x: 418
        y: 860 // Add this line

        onClicked: {
            buttons.adjustButtons("Left");
            isToggled = !isToggled; // This line toggles the state
        }
        width: 100
        height: 100

        contentItem: Image {
            id: leftImage
            width: 100
            height: 100
            source: "image/turn_left.png"
        }

        background: Rectangle {
            color: "transparent"
        }
    }
    Button {
        id: buttonRight
        property bool isToggled: false
        x: 1315
        y: 860 // Add this line

        onClicked: {
            buttons.adjustButtons("Right");
            isToggled = !isToggled; // This line toggles the state
        }
        width: 100
        height: 100

        contentItem: Image {
            id: rightImage
            width: 100
            height: 100
            source: "image/turn_right.png"
        }

        background: Rectangle {
            color: "transparent"
        }
    }

    Button {
        id: buttonLight
        property bool isToggled: false
        x: 1056
        y: 860 // Add this line

        onClicked: {
            buttons.adjustButtons("Light");
            isToggled = !isToggled; // This line toggles the state
        }
        width: 200
        height: 120

        contentItem: Image {
            id: starImage
            width: 100
            height: 100
            source: buttonLight.isToggled ? "image/on.png" : "image/off.png" // Use the state here
        }

        background: Rectangle {
            color: "transparent"
        }
    }
    Button {
        id: buttonMap
        property bool isToggled: false
        x: 635
        y: 860 // Add this line

        onClicked: {
            buttons.adjustButtons("naver");
            isToggled = !isToggled; // This line toggles the state
        }
        width: 100
        height: 100

        contentItem: Image {
            id: mapImage
            width: 100
            height: 100
            source: "image/MapIcon.png"
        }

        background: Rectangle {
            color: "transparent"
        }
    }
//    Button {
//            id: buttonMc
//            property bool isToggled: false
//            x: 354
//            y: 650 // Add this line

//            onClicked: {
//                buttons.adjustButtons("Mc");
//                isToggled = !isToggled; // This line toggles the state
//            }
//            width: 100
//            height: 100

//            contentItem: Image {
//                id: mcImage
//                width: 100
//                height: 100
//                source: "image/mc.png" // Use the state here
//            }

//            background: Rectangle {
//                color: "transparent"
//            }
//        }

    Text {
        id: text1
        x: 633
        y: 91
        text: qsTr("Speed")
        font.bold: true
        font.pixelSize: 36
    }

    Text {
        id: text2
        x: 1120
        y: 91
        text: qsTr("RPM")
        font.bold: true
        font.pixelSize: 36
    }





}




