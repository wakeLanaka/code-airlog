#ifndef AIRLOG_INDOORCLIMATEHISTORYMANAGER_H
#define AIRLOG_INDOORCLIMATEHISTORYMANAGER_H

#include <QVariantList>
#include <QObject>
#include <qqmlintegration.h>
#include <QSqlDatabase>

class IndoorClimateHistoryManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QVariantList temperatureData READ temperatureData CONSTANT)
    Q_PROPERTY(QVariantList co2Data READ co2Data CONSTANT)
    Q_PROPERTY(QVariantList humidityData READ humidityData CONSTANT)

public:
    explicit IndoorClimateHistoryManager(QObject* parent = nullptr);
    ~IndoorClimateHistoryManager() override;

    QVariantList temperatureData();
    QVariantList co2Data();
    QVariantList humidityData();

    void fetchChartData();

private:
    QSqlDatabase m_database;
    QVariantList m_temperatureData;
    QVariantList m_co2Data;
    QVariantList m_humidityData;
};


#endif
