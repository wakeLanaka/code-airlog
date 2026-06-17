import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Hardware.Sensors 1.0

Window {
    visible: true
    visibility: Window.FullScreen
    title: "Airlog"
    color: "#121214"

    property int textPixelSize: 48
    property int unitPixelSize: 40
    property int valuePixelSize: 56

    property int circleRadius: 250

    TemperatureSensor {
        id: temperatureSensor
    }

    function getAccentColor() {
        if (temperatureSensor.temperature < 0) {
            return "#00f0b5";
        } else if (temperatureSensor.temperature < 30) {
            return "#b2b57c";
        }
        return "#ff4a5a";
    }

    property double minTemp: 0.0
    property double maxTemp: 50.0
    property color accentColor: getAccentColor()

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Row {
            anchors.centerIn: parent
            spacing: 30
            Column {
                spacing: 30

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Temp."
                    font.pixelSize: textPixelSize
                    font.bold: true
                    color: "#6b7280"
                }

                Item {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: circleRadius
                    height: circleRadius

                    Rectangle {
                        anchors.fill: parent
                        radius: width / 2
                        color: "transparent"
                        border.color: "#26262b"
                        border.width: width / 20
                    }

                    Row {
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            text: temperatureSensor.temperature.toFixed(1)
                            font.pixelSize: valuePixelSize
                            font.bold: true
                            color: "#8f949c"
                        }

                        Text {
                            text: "°C"
                            font.pixelSize: unitPixelSize
                            font.bold: true
                            color: accentColor

                            Behavior on color {
                                ColorAnimation {
                                    duration: 400
                                }
                            }
                        }
                    }
                }
            }

            Column {
                spacing: 30

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "CO2"
                    font.pixelSize: textPixelSize
                    font.bold: true
                    color: "#6b7280"
                }

                Item {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: circleRadius
                    height: circleRadius

                    Rectangle {
                        anchors.fill: parent
                        radius: width / 2
                        color: "transparent"
                        border.color: "#26262b"
                        border.width: width / 20
                    }

                    Row {
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            text: temperatureSensor.co2.toFixed(1)
                            font.pixelSize: valuePixelSize
                            font.bold: true
                            color: "#8f949c"
                        }

                        Text {
                            text: "ppm"
                            font.pixelSize: unitPixelSize
                            font.bold: true
                            color: accentColor

                            Behavior on color {
                                ColorAnimation {
                                    duration: 400
                                }
                            }
                        }
                    }
                }
            }

            Column {
                spacing: 30

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Humidity"
                    font.pixelSize: textPixelSize
                    font.bold: true
                    color: "#6b7280"
                }

                Item {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: circleRadius
                    height: circleRadius

                    Rectangle {
                        anchors.fill: parent
                        radius: width / 2
                        color: "transparent"
                        border.color: "#26262b"
                        border.width: width / 20
                    }

                    Row {
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            text: temperatureSensor.humidity.toFixed(1)
                            font.pixelSize: valuePixelSize
                            font.bold: true
                            color: "#8f949c"
                        }

                        Text {
                            text: "%"
                            font.pixelSize: unitPixelSize
                            font.bold: true
                            color: accentColor

                            Behavior on color {
                                ColorAnimation {
                                    duration: 400
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}