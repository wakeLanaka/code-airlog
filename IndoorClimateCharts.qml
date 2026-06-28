import QtQuick
import QtQuick.Controls
import QtCharts
import Airlog 1.0

Item {
    id: chartsRoot
    anchors.fill: parent
    visible: false

    signal closeCharts()

    property int activeChartType: -1

    function reloadTemperatureData() {
        temperatureLineSeries.clear();
        indoor.temperatureData.forEach(value => temperatureLineSeries.append(value.x, value.y));
    }

    function reloadCo2Data() {
        co2LineSeries.clear();
        indoor.co2Data.forEach(value => co2LineSeries.append(value.x, value.y));
    }

    function reloadHumidityData() {
        humidityLineSeries.clear();
        indoor.humidityData.forEach(value => humidityLineSeries.append(value.x, value.y));
    }

    IndoorClimateHistoryManager {
        id: indoor
    }

    function isTemperatureChartVisible() {
        return chartsRoot.activeChartType === ChartType.Type.TEMPERATURE;
    }

    function isCo2ChartVisible() {
        return chartsRoot.activeChartType === ChartType.Type.CO2;
    }

    function isHumidityChartVisible() {
        return chartsRoot.activeChartType === ChartType.Type.HUMIDITY;
    }

    onActiveChartTypeChanged: {
        switch (activeChartType) {
            case ChartType.Type.TEMPERATURE:
                reloadTemperatureData()
                break;
            case ChartType.Type.CO2:
                reloadCo2Data()
                break;
            case ChartType.Type.HUMIDITY:
                reloadHumidityData()
                break;
        }
    }

    ChartView {
        id: chartView
        anchors.fill: parent
        antialiasing: true
        theme: ChartView.ChartThemeDark

        property color lineColor: "#8f949c"

        Button {
            anchors.fill: parent
            background: Rectangle {
                color: "transparent"
            }
            onClicked: {
                closeCharts();
            }
        }

        DateTimeAxis {
            id: indoorClimateDateTimeAxis
            format: "hh:mm"
            tickCount: 10
            min: {
                const date = new Date()
                date.setHours(date.getHours() - 12);
                return date;
            }
            max: new Date()
        }

        ValueAxis {
            id: axisYTemperature
            min: 20
            max: 35
            tickCount: 10
            visible: isTemperatureChartVisible()
        }

        ValueAxis {
            id: axisYCo2
            min: 300
            max: 2000
            tickCount: 10
            visible: isCo2ChartVisible()
        }

        ValueAxis {
            id: axisYHumidity
            min: 0
            max: 100
            tickCount: 10
            visible: isHumidityChartVisible()
        }

        SplineSeries {
            id: temperatureLineSeries
            name: "Temperature (°C)"
            visible: isTemperatureChartVisible()

            axisX: indoorClimateDateTimeAxis
            axisY: axisYTemperature
            color: chartView.lineColor
        }

        SplineSeries {
            id: co2LineSeries
            name: "CO2 (ppm)"
            visible: isCo2ChartVisible()

            axisX: indoorClimateDateTimeAxis
            axisY: axisYCo2
            color: chartView.lineColor
        }

        SplineSeries {
            id: humidityLineSeries
            name: "Humidity (%)"
            visible: isHumidityChartVisible()

            axisX: indoorClimateDateTimeAxis
            axisY: axisYHumidity
            color: chartView.lineColor
        }
    }
}
