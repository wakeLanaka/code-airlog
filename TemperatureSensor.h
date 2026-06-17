#ifndef AIRLOG_TEMPERATURESENSOR_H
#define AIRLOG_TEMPERATURESENSOR_H
#include <qqmlintegration.h>
#include <QTimer>


class TemperatureSensor : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double temperature READ temperature NOTIFY temperatureChanged)
    Q_PROPERTY(double co2 READ co2 NOTIFY co2Changed)
    Q_PROPERTY(double humidity READ humidity NOTIFY humidityChanged)
    QML_ELEMENT

public:
    explicit TemperatureSensor(QObject* parent = nullptr);
    ~TemperatureSensor() override;
    [[nodiscard]] double temperature() const;
    [[nodiscard]] double co2() const;
    [[nodiscard]] double humidity() const;

signals:
    void temperatureChanged(double newTemperature);
    void co2Changed(double newCo2);
    void humidityChanged(double newHumidity);

private slots:
    void readTemperature();

private:
    [[nodiscard]] bool isDataReady() const;

    double m_currentTemperature{};
    double m_currentCo2{};
    double m_currentHumidity{};
    int m_i2cFileDescriptor = -1;
    QTimer* m_readTimer;
};

#endif
