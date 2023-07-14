import QtQuick 2.7
import QtQuick.Controls 2.2
import "."
import QtMultimedia 5.5
import QtLocation 5.9
import QtPositioning 5.9
//import QtMultimedia 5.15



ApplicationWindow {
    visible: true
    width: screen.width
    height: screen.height
    property alias gearImage: gearImage
    property alias fuelImage: fuelImage
    property string bState: "P"
    property bool showWeather: false
    property bool showWarn: false
    property bool showLight: false
    property bool showleft: false
    property bool showright: false
    title: qsTr("Speedometer")
    // Background Image
    Image {
        id: backgroundImage
        anchors.fill: parent
        source: "image/back1.png" // Replace with the path to your background image
    }

    Map {
            id: map


            plugin: otherPlugin

            center: magione
            gesture.enabled: true
            width: 926
            height: 531

            layer.effect: map
            smooth: true
            opacity: 1
            clip: true
            transformOrigin: Item.Center
            layer.wrapMode: ShaderEffectSource.ClampToEdge
            anchors.verticalCenterOffset: -174
            anchors.horizontalCenterOffset: 0
            anchors.centerIn: parent
            zoomLevel: 20
            bearing: 37.602365 +360
            tilt: 60
            layer.enabled: False
            visible:false

            PositionSource {
                         id: src
                         updateInterval: 1000
                         active: true

                         onPositionChanged: {
                             var coord = src.position.coordinate;
                             console.debug("current position:", coord.latitude, coord.longitude);
                         }
                     }




                     MapItemView {

                         model: routeModel
                         delegate: MapRoute {
                             route: routeData
                             line.color: "blue"
                             line.width: 4
                             smooth: true



                         }
                     }

                     RouteQuery {
                             id: routeQuery
                         }

                    RouteModel {
                         id: routeModel
                         plugin: otherPlugin
                         query: routeQuery
                         autoUpdate: true

                         Component.onCompleted: {
                             updateRoute()
                             startTimer() // 타이머 시작
                         }

                         function updateRoute() {
                             routeQuery.clearWaypoints()
                             routeQuery.addWaypoint(QtPositioning.coordinate(myCoordinate1.latitude, myCoordinate1.longitude))
                             routeQuery.addWaypoint(QtPositioning.coordinate(myCoordinate2.latitude, myCoordinate2.longitude))

                             routeModel.update()
                         }
                     }

                     Timer {
                         interval: 1000 // 5초 (5000 밀리초)
                         repeat: true // 반복 실행
                         running: true // 타이머 시작

                         onTriggered: {
                             routeModel.updateRoute()
                         }
                     }




                      MapPolygon {
                                  color: 'green'
                                  path: [
                                      QtPositioning.coordinate(myCoordinate1.latitude+0.00008, myCoordinate1.longitude+0.00008),
                                      QtPositioning.coordinate(myCoordinate1.latitude+0.00008, myCoordinate1.longitude-0.00008),
                                      QtPositioning.coordinate(myCoordinate1.latitude, myCoordinate1.longitude)
                                  ]


                              }
                      MapPolygon {
                                  color: 'red'
                                  path: [
                                      QtPositioning.coordinate(myCoordinate2.latitude+0.00008, myCoordinate2.longitude+0.00008),
                                      QtPositioning.coordinate(myCoordinate2.latitude+0.00008, myCoordinate2.longitude-0.00008),
                                      QtPositioning.coordinate(myCoordinate2.latitude, myCoordinate2.longitude)

                                  ]


                          }



            MapItemView {
                model: searchModel
                delegate: MapCircle {
                    center: model.place.location.coordinate

                    radius: 50
                    color: "#aa449944"
                    border.width: 0
                }
            }




            MapCircle {
                center {
                    latitude: 37.602795
                    longitude: 127.024114
                }
                radius: 1
                color: 'green'
                border.width: 3
            }


        }

            Rectangle {
                   id: mask
                   x: -798
                   y: -453
                   width: 564
                   height: 567
                   radius: width / 2
                   anchors.verticalCenterOffset: -175
                   anchors.horizontalCenterOffset: -548
                    anchors.centerIn: parent
                   color: "#212121"
                   opacity: 1
               }

            Rectangle {
                id: mask1
                x: -807
                y: -461
                width: 564
                height: 567
                color: "#212121"
                radius: width / 2
                anchors.horizontalCenterOffset: 548
                anchors.centerIn: parent
                opacity: 1
                anchors.verticalCenterOffset: -174
            }

    Image {
        id: speedImage
        width: 590
        height: 590
        anchors.verticalCenterOffset: -175
        anchors.horizontalCenterOffset: -548
        anchors.centerIn: parent
        source: "image/speedmachine.png" // Replace with the path to your arc image
    }

    Image {
        id: speedImage2
        width: 590
        height: 590
        anchors.verticalCenterOffset: -175
        anchors.horizontalCenterOffset: 548  // 오른쪽으로 이동
        anchors.centerIn: parent
        source: "image/speedmachine.png" // Replace with the path to your arc image
        transform: Scale {
            xScale: -1 // x 방향으로 반전
            origin.x: speedImage.width / 2  // 반전의 기준점을 이미지 중앙으로 설정
            origin.y: speedImage.height / 2
        }
    }
//    Image {
//        id: rpmImage
//        width: 550
//        height: 550
//        anchors.verticalCenterOffset: -185
//        anchors.horizontalCenterOffset: 527
//        anchors.centerIn: parent
//        source: "image/rpm.png" // Replace with the path to your arc image
//    }
    // Car Image

    Text {
            id: emotionText
            font.pixelSize: 50
            font.bold: true
            color: 'yellow'
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            visible: myCoordinate9.latitude === 1  // myCoordinate9의 latitude 값이 1인 경우에만 텍스트 표시

            states: [
                State {
                    name: "showTextState"
                    when: emotionText.visible

                    PropertyChanges {
                        target: emotionText
                        text: "Calm down"
                    }
                }
            ]

            transitions: [
                Transition {
                    from: "*"
                    to: "showTextState"
                    PropertyAnimation {
                        target: emotionText
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 500
                    }
                }
            ]
        }

    Image {
        id: carImage
        y: -484
        width: 412*2 // Adjust the width of the car image
        height: 299*2
        anchors.horizontalCenterOffset: 0
        anchors.bottomMargin: 95 // Adjust the height of the car image
        source: "image/bg-mask.png" // Replace with the path to your car image
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            margins: 20
        }
    }
    Image {
        id: carhi
        y: -484
        width: 412*2 // Adjust the width of the car image
        height: 299*2
        anchors.horizontalCenterOffset: 0
        anchors.bottomMargin: 95 // Adjust the height of the car image
        source: "image/car-highlights.png" // Replace with the path to your car image
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            margins: 20
        }
    }
    Image {
        id: weatherIcon
        width: 166
        height: 166
        anchors.verticalCenterOffset: -46
        anchors.horizontalCenterOffset: 0
        anchors.centerIn: parent
        source: weatherAPI.weatherIcon
        visible: false
    }
    Image {
        id: warnIcon
        width: 864
        height: 80
        anchors.verticalCenterOffset: -506
        anchors.horizontalCenterOffset: 0
        anchors.centerIn: parent
        source: "image/warning.png"
        visible: showWarn
    }
    Timer {
        id: blinkTimer
        interval: 500 // Blink every 500ms
        running: false // Don't start running automatically
        repeat: true
        onTriggered: {
            warnIcon.visible = !warnIcon.visible // Toggle visibility
        }
    }
    Image {
        id: leftIcon
        width: 100
        height: 80
        anchors.verticalCenterOffset: -506
        anchors.horizontalCenterOffset: -380
        anchors.centerIn: parent
        source: "image/warningleft.png"
        visible: showleft
    }
    Timer {
        id: blinkleftTimer
        interval: 500 // Blink every 500ms
        running: false // Don't start running automatically
        repeat: true
        onTriggered: {
            leftIcon.visible = !leftIcon.visible // Toggle visibility
        }
    }
    Image {
        id: rightIcon
        width: 100
        height: 80
        anchors.verticalCenterOffset: -506
        anchors.horizontalCenterOffset: 380
        anchors.centerIn: parent
        source: "image/warningleft.png"
        transform: Scale {
            xScale: -1 // x 방향으로 반전
            origin.x: leftIcon.width / 2  // 반전의 기준점을 이미지 중앙으로 설정
            origin.y: leftIcon.height / 2
        }
        visible: showright
    }
    Timer {
        id: blinkrightTimer
        interval: 500 // Blink every 500ms
        running: false // Don't start running automatically
        repeat: true
        onTriggered: {
            rightIcon.visible = !rightIcon.visible // Toggle visibility
        }
    }

    Image {
        id: lightIcon
        width: 80
        height: 80
        anchors.verticalCenterOffset: -506
        anchors.horizontalCenterOffset: -548
        anchors.centerIn: parent
        source: "image/star.png"
        visible: showLight
    }
    Text {
        id: temperature
        font.pixelSize: 28
        font.bold: true
        font.italic: true
        color: '#cadfff'
        x: 955
        y: 962
        //anchors.horizontalCenter: weatherIcon.horizontalCenter
        //anchors.top: weatherIcon.bottom
        //anchors.topMargin: 40
        text: weatherAPI.temperature + "°C"
        visible: true
        //anchors.horizontalCenterOffset: 1
    }

//    Canvas {
//                id: speedpointer
//                width: parent.width
//                height: parent.height
//                anchors.verticalCenterOffset: -170
//                anchors.horizontalCenterOffset: -548
//                rotation: 180
//                anchors.centerIn: parent
//                onPaint: {
//                    var ctx = getContext('2d');
//                    var centerX = width / 2;
//                    var centerY = height / 2;

//                    // Clear the canvas
//                    ctx.clearRect(0, 0, width, height);

//                    // Draw the speed bar
//                    var angle = (speedReceiver.speedValue - 130) * Math.PI / 260; // Convert speed to angle
//                    ctx.beginPath();
//                    ctx.moveTo(centerX, centerY);
//                    ctx.lineTo(centerX + 160 * Math.cos(angle), centerY + 160 * Math.sin(angle));
//                    ctx.lineWidth = 5;
//                    ctx.strokeStyle = '#ff0000';
//                    ctx.stroke();
//                }

//                Connections {
//                    target: speedReceiver
//                    onSpeedValueChanged: {
//                        speedpointer.requestPaint()
//                    }
//                }
//    }
//    Canvas {
//        id: rpmpointer
//        width: parent.width
//        height: parent.height
//        anchors.verticalCenterOffset: -170
//        anchors.horizontalCenterOffset: 548￣
//        rotation: 180
//        anchors.centerIn: parent
//        onPaint: {
//            var ctx = getContext('2d');
//            var centerX = width / 2;
//            var centerY = height / 2;

//            // Clear the canvas
//            ctx.clearRect(0, 0, width, height);

//            // Draw the speed bar
//            var angle = ((rpmReceiver.rpmValue) -4000) * Math.PI / 8000; // Convert rpm to angle
//            ctx.beginPath();
//            ctx.moveTo(centerX, centerY);
//            ctx.lineTo(centerX - 160 * Math.cos(angle), centerY + 160 * Math.sin(angle));
//            ctx.lineWidth = 5;
//            ctx.strokeStyle = '#ff0000';
//            ctx.stroke();
//        }

//        Connections {
//            target: rpmReceiver
//            onRpmValueChanged: {
//                rpmpointer.requestPaint()
//            }
//        }
//    }

    Text {
           id: speed
           anchors.horizontalCenter: speedImage.horizontalCenter
           anchors.verticalCenter: speedImage.verticalCenter
           text: speedReceiver.speedValue
           font.pixelSize: 100
           font.family: "Sarabun"
           color: "#cadfff"
           font.bold: true
           Connections {
               target: speedReceiver
               onSpeedValueChanged: {
                   speedpointer.requestPaint()
               }
           }
    }
    Text {
           id: kmh
           anchors.horizontalCenter: speedImage.horizontalCenter
           anchors.top: speedImage.bottom
           anchors.topMargin: -speedImage.height/2+speedImage.height/15
           text: "km/h"
           font.pixelSize: 30
           font.italic: true
           font.family: "Sarabun"
           color: "#cadfff"
           Connections {
               target: speedReceiver
               onSpeedValueChanged: {
                   speedpointer.requestPaint()
               }
           }
    }
    Text {
        id: rpmnum
        anchors.horizontalCenter: speedImage2.horizontalCenter
        anchors.verticalCenter: speedImage2.verticalCenter
        text: rpmReceiver.rpmValue
        font.pixelSize: 100
        font.family: "Sarabun"
        color: "#cadfff"
        font.bold: true
        Connections {
            target: rpmReceiver
            onRpmValueChanged: {
                rpmpointer.requestPaint()
            }
        }
    }
    Text {
        id: rpm
        anchors.horizontalCenter: speedImage2.horizontalCenter
        anchors.top: speedImage.bottom
        anchors.topMargin: -speedImage.height/2+speedImage.height/15
        text: "RPM"
        font.pixelSize: 30
        font.family: "Sarabun"
        color: "#cadfff"
        Connections {
            target: rpmReceiver
            onRpmValueChanged: {
                rpmpointer.requestPaint()
            }
        }
    }
    Text {
        id: odoText
        font.pixelSize: 20
        font.italic: true
        font.bold: false
        text: "ODO"
        color: 'gray'
        x: 0
        y: 1105
    }
    Text {
        id: mmText
        font.pixelSize: 20
        font.italic: true
        font.bold: true
        text: Math.floor(newVariable).toString() // 소수점 아래 수들이 출력되지 않도록 정수로 변환
        color: '#cadfff'
        x: 48
        y: 1105
    }

    property real newVariable: 0 // 초기값은 0으로 설정

    Timer {
        interval: 1000 // 1초마다 실행되도록 설정
        running: true
        repeat: true
        onTriggered: {
            newVariable += speedReceiver.speedValue / 3600
            mmText.text = Math.floor(newVariable).toString() // 소수점 아래 수들이 출력되지 않도록 정수로 변환
        }
    }

    Text {
        id: kmText
        font.pixelSize: 20
        font.italic: true
        font.bold: false
        text: "km"
        color: 'gray'
        x: 85
        y: 1105
    }
    Text {
        id: rangeText
        font.pixelSize: 20
        font.italic: true
        font.bold: false
        text: "RANGE"
        color: 'gray'
        x: 120
        y: 1105
    }
    Text {
        id: distanceText
        font.pixelSize: 20
        font.italic: true
        font.bold: true
        text: 25-Math.floor(newVariable).toString()
        color: '#cadfff'
        x: 190
        y: 1105
    }
    property real newVariable2: 25 // 초기값은 0으로 설정
    Timer {
        interval: 1000 // 1초마다 실행되도록 설정
        running: true
        repeat: true
        onTriggered: {
            newVariable2 -= speedReceiver.speedValue / 3600
            mmText.text = Math.floor(newVariable).toString() // 소수점 아래 수들이 출력되지 않도록 정수로 변환
        }
    }
    Text {
            id: currentTime
            font.pixelSize: 20
            font.bold: true
            font.family: "Sarabun"
            color: '#cadfff'
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
        }
    Timer {
        interval: 1000 // Update every 1 second
        running: true
        repeat: true
        onTriggered: {
            var now = new Date();
            var hours = now.getHours().toString().padStart(2, '0'); // Get hours and pad with leading zero if necessary
            var minutes = now.getMinutes().toString().padStart(2, '0'); // Get minutes and pad with leading zero if necessary
            //var seconds = now.getSeconds().toString().padStart(2, '0'); // Get seconds and pad with leading zero if necessary
            currentTime.text = hours + ':' + minutes; // Update the current time
        }
    }

    Text {
        id: kmmText
        font.pixelSize: 20
        font.italic: true
        font.bold: false
        text: "km"
        color: 'gray'
        x: 230
        y: 1105
    }









    Row {
        anchors.verticalCenterOffset: 486
        anchors.horizontalCenterOffset: 0
        anchors.centerIn: parent
        spacing: 10

        Text {
            id: pText
            font.pixelSize: 130
            font.italic: true
            font.bold: true
            text: "P"
            color: 'red'
        }

        Text {
            id: rText
            font.pixelSize: 130
            font.italic: true
            font.bold: true
            text: "R"
            color: 'white'
        }

        Text {
            id: nText
            font.pixelSize: 130
            font.italic: true
            font.bold: true
            text: "N"
            color: 'white'
        }

        Text {
            id: dText
            font.pixelSize: 130
            font.italic: true
            font.bold: true
            text: "D"
            color: 'white'
        }
//        Text {
//            id: jText
//            font.pixelSize: 130
//            font.italic: true
//            font.bold: true
//            text: "J"
//            color: 'white'
//        }

        Connections {
            target: buttonsReceiver
            onButtonsValueChanged: {
                var buttonValue = buttonsReceiver.buttonsValue;

                if (buttonValue === "P" || buttonValue === "R" || buttonValue === "N" || buttonValue === "D") {
                    bState = buttonValue;
                    pText.color = bState === "P" ? 'red' : 'white';
                    rText.color = bState === "R" ? 'red' : 'white';
                    nText.color = bState === "N" ? 'red' : 'white';
                    dText.color = bState === "D" ? 'red' : 'white';
                    //jText.color = bState === "J" ? 'red' : 'white';

                    gearImage.visible = bState === "P";
                    videoOutput.visible = bState === "R";
                    arrowfImage.visible = bState === "D";

                    //dogImage.visible = bState === "J";
                }
//                else if(buttonValue === "Weather"){
//                    showWeather = !showWeather;
//                    weatherAPI.requestWeather("Seoul");
//                }
                else if(buttonValue === "Warn"){
                    if (showWarn) {
                        blinkTimer.stop(); // Stop blinking
                        warnIcon.visible = false; // Ensure the icon is hidden
                    } else {
                        blinkTimer.start(); // Start blinking
                    }
                    showWarn = !showWarn;
                }
                else if(buttonValue === "Left"){
                    bState = buttonValue;
                    if (showleft) {
                        blinkleftTimer.stop(); // Stop blinking
                        leftIcon.visible = false; // Ensure the icon is hidden
                        leftcamera.stop();
                        arrowlImage.visible = false;
                    } else {
                        blinkleftTimer.start(); // Start blinking
                        leftcamera.start();
                    }
                    showleft = !showleft;
                    leftOutput.visible = bstate === "Left";
                    arrowlImage.visible = bstate === "Left";
                }
                else if(buttonValue === "Right"){
                    bState = buttonValue;
                    if (showright) {
                        blinkrightTimer.stop(); // Stop blinking
                        rightIcon.visible = false; // Ensure the icon is hidden
                        rightcamera.stop();
                        arrowrImage.visible = false;
                    } else {
                        blinkrightTimer.start(); // Start blinking
                        rightcamera.start();
                    }
                    showright = !showright;
                    rightOutput.visible = bstate === "Right";
                    arrowrImage.visible = bstate === "Right";

                }
                else if(buttonValue === "Light"){
                    showLight = !showLight;
                }
                else if (buttonValue === "naver") {
                        map.visible = !map.visible;
                    }
            }
        }

    }
    Item {
        id: root

        Timer {
            id: blinkFuelTimer
            interval: 500 // Blink every 500ms
            running: newVariable2 < 10 && newVariable2 > 8 // Start the timer when the condition is met
            repeat: true
            onTriggered: {
                myText.visible = !myText.visible // Toggle visibility
                empty.visible= !empty.visible
            }
        }

        Text {
            id: myText
            text: " 주행가능거리 " + Math.floor(newVariable2+1).toString() + " km \n"+"    "+"주유하십시오!"
            color: "Red"
            font.pixelSize: 25
            font.bold: true
            font.italic: true
            font.family: "Sarabun"
            visible: newVariable2 < 10 && 8<newVariable2
            x: 880
            y: 500
            // 다른 속성 설정들...
        }
        Image {
                id: empty
                width: 100
                height: 80
                scale: 1
                x: 815
                y: 495
                source: "image/empty.png" // Replace with the path to your image
                visible: newVariable2 < 10 && 8<newVariable2 // Show the image when the timer is running
            }

    }





    Image {
        id: gearImage
        width: 400
        height: 400
        scale: 1
        anchors.verticalCenterOffset: -334
        anchors.horizontalCenterOffset: 1
        anchors.centerIn: parent
        source: "image/volk.png" // Replace with the path to your image
        visible: bState === "P"
    }
    Image {
        id: fuelImage
        width: 22
        height: 22
        scale: 1
        x: 1800
        y: 1105
        //anchors.verticalCenterOffset: -334
        //anchors.horizontalCenterOffset: 1
        //anchors.centerIn: parent
        source: "image/fuel.png" // Replace with the path to your image￣
    }
    Image {
        id: fuelbImage_full
        width: 100
        height: 22
        scale: 1
        x: 1830
        y: 1103
        //anchors.verticalCenterOffset: -334
        //anchors.horizontalCenterOffset: 1
        //anchors.centerIn: parent
        source: "image/fuelb.png" // Replace with the path to your image￣
        visible: 20<newVariable2 && newVariable2<=25

    }
//    Image {
//        id: fuelbImage_90
//        width: 90
//        height: 22
//        scale: 1
//        x: 1830
//        y: 1103
//        //anchors.verticalCenterOffset: -334
//        //anchors.horizontalCenterOffset: 1
//        //anchors.centerIn: parent
//        source: "image/fuelb.png" // Replace with the path to your image￣
//        visible: 48<newVariable2 && newVariable2<=49
//    }

    Image {
        id: fuelbImage_80
        width: 80
        height: 22
        scale: 1
        x: 1830
        y: 1103
        //anchors.verticalCenterOffset: -334
        //anchors.horizontalCenterOffset: 1
        //anchors.centerIn: parent
        source: "image/fuelb.png" // Replace with the path to your image￣
        visible: 15<newVariable2 && newVariable2<=20
    }
//    Image {
//        id: fuelbImage_70
//        width: 70
//        height: 22
//        scale: 1
//        x: 1830
//        y: 1103
//        //anchors.verticalCenterOffset: -334
//        //anchors.horizontalCenterOffset: 1
//        //anchors.centerIn: parent
//        source: "image/fuelb.png" // Replace with the path to your image￣
//        visible: 46<newVariable2 && newVariable2<=47
//    }
    Image {
        id: fuelbImage_60
        width: 60
        height: 22
        scale: 1
        x: 1830
        y: 1103
        //anchors.verticalCenterOffset: -334
        //anchors.horizontalCenterOffset: 1
        //anchors.centerIn: parent
        source: "image/fuelb.png" // Replace with the path to your image￣
        visible: 10<newVariable2 && newVariable2<=15
    }
//    Image {
//        id: fuelbImage_50
//        width: 50
//        height: 22
//        scale: 1
//        x: 1830
//        y: 1103
//        //anchors.verticalCenterOffset: -334
//        //anchors.horizontalCenterOffset: 1
//        //anchors.centerIn: parent
//        source: "image/fuelb.png" // Replace with the path to your image￣
//        visible: 49<newVariable2 && newVariable2<=50
//    }
    Image {
        id: fuelbImage_40
        width: 40
        height: 22
        scale: 1
        x: 1830
        y: 1103
        //anchors.verticalCenterOffset: -334
        //anchors.horizontalCenterOffset: 1
        //anchors.centerIn: parent
        source: "image/fuelb.png" // Replace with the path to your image￣
        visible: 5<newVariable2 && newVariable2<=10
    }
//    Image {
//        id: fuelbImage_30
//        width: 30
//        height: 22
//        scale: 1
//        x: 1830
//        y: 1103
//        //anchors.verticalCenterOffset: -334
//        //anchors.horizontalCenterOffset: 1
//        //anchors.centerIn: parent
//        source: "image/fuelb.png" // Replace with the path to your image￣
//        visible: 49<newVariable2 && newVariable2<=50
//    }
    Image {
        id: fuelbImage_20
        width: 20
        height: 22
        scale: 1
        x: 1830
        y: 1103
        //anchors.verticalCenterOffset: -334
        //anchors.horizontalCenterOffset: 1
        //anchors.centerIn: parent
        source: "image/fuelb.png" // Replace with the path to your image￣
        visible: 0<newVariable2 && newVariable2<=5
    }
//    Image {
//        id: fuelbImage_10
//        width: 10
//        height: 22
//        scale: 1
//        x: 1830
//        y: 1103
//        //anchors.verticalCenterOffset: -334
//        //anchors.horizontalCenterOffset: 1
//        //anchors.centerIn: parent
//        source: "image/fuelb.png" // Replace with the path to your image￣
//        visible: 49<newVariable2 && newVariable2<=50
//    }
    Image {
        id: fuelbImage_0
        width: 0
        height: 22
        scale: 1
        x: 1830
        y: 1103
        //anchors.verticalCenterOffset: -334
        //anchors.horizontalCenterOffset: 1
        //anchors.centerIn: parent
        source: "image/fuelb.png" // Replace with the path to your image￣
        visible: 49<newVariable2 && newVariable2<=50
    }
    Image {
        id: arrowfImage
        x: 975
        y: 680
        width: 40 // Adjust the width of the car image
        height: 70
        source: "image/arrow0.png"
        visible: bState === "D"
    }
    Image {
        id: arrowrImage
        x: 975
        y: 680
        width: 40 // Adjust the width of the car image
        height: 70
        source: "image/arrow90.png"
        visible: bState === "Right"
    }
    Image {
        id: arrowlImage
        x: 975
        y: 680
        width: 40 // Adjust the width of the car image
        height: 70
        source: "image/arrow90.png"
        visible: bState === "Left"
        transform: Scale {
            xScale: -1 // x 방향으로 반전
            origin.x: arrowrImage.width / 2  // 반전의 기준점을 이미지 중앙으로 설정
            origin.y: arrowrImage.height / 2
        }
    }


//    Camera {
//        id: camera
//        deviceId: "/dev/video3"
//    }

//    VideoOutput {
//        id: videoOutput
//        width: 492 // Set width of the camera output
//        height: 441
//        anchors.verticalCenterOffset: -334
//        anchors.horizontalCenterOffset: 0 // Set height of the camera output
//        anchors.horizontalCenter: parent.horizontalCenter // Center the output horizontally
//        anchors.verticalCenter: parent.verticalCenter // Center the output vertically
//        source: camera
//        visible: bState === "R"
//    }

//    Camera {
//            id: leftcamera
//            deviceId: "/dev/video2"
//        }
//            VideoOutput {
//                id: leftOutput
//                width: 492 // Set width of the camera output
//                height: 441
//                anchors.verticalCenterOffset: -334
//                anchors.horizontalCenterOffset: 0 // Set height of the camera output
//                anchors.horizontalCenter: parent.horizontalCenter // Center the output horizontally
//                anchors.verticalCenter: parent.verticalCenter // Center the output vertically
//                source: leftcamera
//                visible: bState === "Left"

//                Component.onCompleted: {
//                       // 웹캠의 해상도 변경
//                       var settings = leftcamera.mediaObject.settings
//                       settings.resolution = Qt.size(200, 240) // 원하는 해상도로 변경
//                       leftcamera.mediaObject.applySettings(settings)
//                   }
//             }
    Camera {
        id: leftcamera
        deviceId: "/dev/video2"
        captureMode: Camera.CaptureVideo
        videoRecorder.resolution: "320x240" // 원하는 해상도로 설정

        Component.onCompleted: {
            // 비디오 해상도 변경 적용
            leftcamera.lock()
            leftcamera.unlock()
        }
    }

    VideoOutput {
        id: leftOutput
        width: 492 // Set width of the camera output
        height: 441
        anchors.verticalCenterOffset: -334
        anchors.horizontalCenterOffset: 0 // Set height of the camera output
        anchors.horizontalCenter: parent.horizontalCenter // Center the output horizontally
        anchors.verticalCenter: parent.verticalCenter // Center the output vertically
        source: leftcamera
        visible: bState === "Left"
    }

    Camera {
            id: rightcamera
            deviceId: "/dev/video1"
            captureMode: Camera.CaptureVideo
            videoRecorder.resolution: "320x240" // 원하는 해상도로 설정

            Component.onCompleted: {
                // 비디오 해상도 변경 적용
                rightcamera.lock()
                rightcamera.unlock()
            }
        }
        VideoOutput {
            id: rightOutput
            width: 492 // Set width of the camera output
            height: 441
            anchors.verticalCenterOffset: -334
            anchors.horizontalCenterOffset: 0 // Set height of the camera output
            anchors.horizontalCenter: parent.horizontalCenter // Center the output horizontally
            anchors.verticalCenter: parent.verticalCenter // Center the output vertically
            source: rightcamera
            visible: bState === "Right"
         }

    property var magione: QtPositioning.coordinate(myCoordinate1.latitude,myCoordinate1.longitude)

           Plugin {
               id: somePlugin
               name: "mapboxgl"

               PluginParameter { name: "mapbox.map_id"; value: "mapbox.satellite" }
               PluginParameter { name: "mapbox.access_token"; value: "pk.eyJ1Ijoic3luYXNpdXMiLCJhIjoiY2lnM3JrdmRjMjJ4b3RqbTNhZ2hmYzlkbyJ9.EA86y0wrXX1eo64lJPTepw" }

           }

           Plugin {
               id: otherPlugin
               name: "osm"
               PluginParameter { name: "osm.mapping.providersrepository.address"; value: "https://tile.thunderforest.com/transport-dark/{z}/{x}/{y}.png?apikey=9389963ff7464ba89e4cb9c5d1e34689"}
               PluginParameter { name: "osm.mapping.host"; value: "https://tile.thunderforest.com/transport-dark/{z}/{x}/{y}.png?apikey=9389963ff7464ba89e4cb9c5d1e34689"}
               PluginParameter { name: "osm.mapping.highdpi_tiles"; value: true }
           }
           Rectangle {
                                     id: black
                                     anchors.fill: parent
                                     color: "black"
                                     opacity: 1

                                     // 애니메이션을 위한 프로퍼티
                                     property real animationDuration: 1000 // 애니메이션 지속 시간 (밀리초)
                                     property real targetOpacity: 0 // 애니메이션 목표 투명도

                                     // 애니메이션 정의
                                     SequentialAnimation {
                                         id: animation
                                         running: false // 초기에는 실행되지 않도록 설정

                                         PropertyAnimation {
                                             target: black
                                             property: "opacity"
                                             to: black.targetOpacity
                                             duration: black.animationDuration
                                             easing.type: Easing.InOutQuad // 선택적으로 이징 설정 가능
                                         }
                                     }

                                       Connections {
                                           target: buttonsReceiver
                                           onButtonsValueChanged: {
                                               var buttonValue = buttonsReceiver.buttonsValue;
                                               if (buttonValue === 'Start') {
                                                   if (black.opacity === 0) {
                                                       black.targetOpacity = 1;
                                                       animation.start();
                                                   } else {
                                                       black.targetOpacity = 0; // 애니메이션의 목표 투명도 설정
                                                       animation.start();
                                                   }
                                               }

                                           }
                                       }
                                 }





}
