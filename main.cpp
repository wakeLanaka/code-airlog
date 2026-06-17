#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QCursor>

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine("qrc:/Hardware/Sensors/main.qml");
    QGuiApplication::setOverrideCursor(QCursor(Qt::BlankCursor));

    return QGuiApplication::exec();
}
