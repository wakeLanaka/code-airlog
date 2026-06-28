import QtQuick
import QtQuick.Controls
import Airlog 1.0

Item {
    id: dashboardRoot
    anchors.fill: parent
    visible: true

    signal chartRequested(int chartType)

    property int textPixelSize: 48
    property int unitPixelSize: 40
    property int valuePixelSize: 56

    property int circleRadius: 250

    function getAccentColor(value, warningLimit, criticalLimit) {
        if (temperatureSensor.co2 < warningLimit) {
            return "#00f0b5";
        } else if (temperatureSensor.co2 < criticalLimit) {
            return "#8f949c";
        }
        return "#ff4a5a";
    }

    TemperatureSensor {
        id: temperatureSensor
    }

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
                    Button {
                        anchors.fill: parent
                        background: Rectangle {
                            color: "transparent"
                        }
                        onClicked: {
                            chartRequested(ChartType.Type.TEMPERATURE);
                        }
                    }
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
                        color: getAccentColor(temperatureSensor.temperature, 0, 24)

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
                    Button {
                        anchors.fill: parent
                        background: Rectangle {
                            color: "transparent"
                        }
                        onClicked: {
                            chartRequested(ChartType.Type.CO2);
                        }
                    }
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
                        color: getAccentColor(temperatureSensor.co2, 1000, 1400)

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
                    Button {
                        anchors.fill: parent
                        background: Rectangle {
                            color: "transparent"
                        }
                        onClicked: {
                            chartRequested(ChartType.Type.HUMIDITY);
                        }
                    }

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
                        color: "#8f949c"

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