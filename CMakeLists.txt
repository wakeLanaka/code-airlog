cmake_minimum_required(VERSION 3.28)
project(airlog)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)


find_package(Qt6 REQUIRED COMPONENTS
        Core
        Gui
        Qml
        Quick
        Sensors
        Sql
        Charts
)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(airlog
        main.cpp
        TemperatureSensor.cpp
        TemperatureSensor.h
        IndoorClimateHistoryManager.cpp
        IndoorClimateHistoryManager.h
)

target_link_libraries(airlog PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
        Qt6::Sensors
        Qt6::Sql
        Qt6::Charts
)


qt_add_qml_module(airlog
        URI Airlog
        VERSION 1.0
        RESOURCE_PREFIX "/"
        QML_FILES
        Main.qml
        DisplayMode.qml
        ChartType.qml
        Dashboard.qml
        IndoorClimateCharts.qml
)

include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})