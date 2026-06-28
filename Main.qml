import QtQuick
import Airlog 1.0
import QtQuick.Controls

ApplicationWindow {
    id: mainWindow
    visible: true
    visibility: Window.FullScreen
    title: "Airlog"
    color: "#121214"


    property int displayMode: DisplayMode.Mode.DASHBOARD
    property int activeChartType: ChartType.Type.TEMPERATURE

    Dashboard {
        id: dashboardContainer
        visible: displayMode === DisplayMode.Mode.DASHBOARD

        onChartRequested: (chartType) => {
            mainWindow.displayMode = DisplayMode.Mode.CHART;
            activeChartType = chartType;
        }
    }

    IndoorClimateCharts {
        id: chartContainer
        visible: displayMode === DisplayMode.Mode.CHART
        activeChartType: mainWindow.activeChartType
        onCloseCharts: () => mainWindow.displayMode = DisplayMode.Mode.DASHBOARD
    }
}