#include "IndoorClimateHistoryManager.h"

#include <QSqlQuery>
#include <QDateTime>
#include <QPointF>
#include <QSqlError>

IndoorClimateHistoryManager::IndoorClimateHistoryManager(QObject* parent) : QObject(parent)
{
    if (!QSqlDatabase::contains("readMetrics"))
    {
        m_database = QSqlDatabase::addDatabase("QPSQL", "readMetrics");
        m_database.setHostName("192.168.1.203");
        m_database.setPort(5433);
        m_database.setDatabaseName("airlog_db");
        m_database.setUserName("TODO");
        m_database.setPassword("TODO");

        if (!m_database.open())
        {
            qCritical() << "Database connection failed:" << m_database.lastError().text();
        }

        fetchChartData();
    }
}

IndoorClimateHistoryManager::~IndoorClimateHistoryManager()
{
    if (m_database.isOpen())
    {
        m_database.close();
        QSqlDatabase::removeDatabase("readMetrics");
    }
}

void IndoorClimateHistoryManager::fetchChartData()
{
    m_temperatureData.clear();
    m_co2Data.clear();
    m_humidityData.clear();

    QSqlQuery query{m_database};
    query.prepare("select measured_at, temperature, co2, humidity from metrics");
    query.exec();

    while (query.next())
    {
        QDateTime date = query.value("measured_at").toDateTime();
        double const temperature = query.value("temperature").toDouble();
        double const co2 = query.value("co2").toDouble();
        double const humidity = query.value("humidity").toDouble();

        m_temperatureData.append(QPointF(date.toMSecsSinceEpoch(), temperature));
        m_co2Data.append(QPointF(date.toMSecsSinceEpoch(), co2));
        m_humidityData.append(QPointF(date.toMSecsSinceEpoch(), humidity));
    }
}

QVariantList IndoorClimateHistoryManager::temperatureData() { return m_temperatureData; }
QVariantList IndoorClimateHistoryManager::co2Data() { return m_co2Data; }
QVariantList IndoorClimateHistoryManager::humidityData() { return m_humidityData; }
