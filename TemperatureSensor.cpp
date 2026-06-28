#include "TemperatureSensor.h"
#include <linux/i2c-dev.h>
#include <linux/i2c.h>
#include <unistd.h>
#include <fcntl.h>
#include <iostream>
#include <sys/ioctl.h>
#include <QSqlError>
#include <QSqlQuery>

#define SCD41_ADDR 0x62

TemperatureSensor::TemperatureSensor(QObject* parent) : QObject(parent)
{
    m_i2cFileDescriptor = open("/dev/i2c-1", O_RDWR);
    if (m_i2cFileDescriptor < 0)
    {
        qWarning() << "Failed to open i2c bus.";
        return;
    }

    if (ioctl(m_i2cFileDescriptor, I2C_SLAVE, SCD41_ADDR) < 0)
    {
        qWarning() << "Could not find SCD41";
    }


    constexpr unsigned char stopPeriodicMeasurement[2] = {0x3F, 0x86};
    if (write(m_i2cFileDescriptor, stopPeriodicMeasurement, 2) != 2)
    {
        qWarning() << "Failed to stop SCD41 measurements.";
    }

    QTimer::singleShot(500, this, [this]()
    {
        constexpr unsigned char startPeriodicMeasurement[2] = {0x21, 0xB1};
        if (write(m_i2cFileDescriptor, startPeriodicMeasurement, 2) == 2)
        {
            m_readTimer = new QTimer(this);
            connect(m_readTimer, &QTimer::timeout, this, &TemperatureSensor::readTemperature);
            m_readTimer->start(30000);

            readTemperature();
        }
    });

    if (!QSqlDatabase::contains("EnvironmentData"))
    {
        m_database = QSqlDatabase::addDatabase("QPSQL", "EnvironmentData");
        m_database.setHostName("192.168.1.203");
        m_database.setPort(5433);
        m_database.setDatabaseName("airlog_db");
        m_database.setUserName("TODO");
        m_database.setPassword("TODO");

        if (!m_database.open())
        {
            qCritical() << "Database connection failed:" << m_database.lastError().text();
        }
    }

    QTimer::singleShot(900000, this, [this]()
    {
        m_writeDatabaseTimer = new QTimer(this);
        connect(m_writeDatabaseTimer, &QTimer::timeout, this,
                &TemperatureSensor::insertDataToDatabase);
        m_writeDatabaseTimer->start(900000);
    });
}

TemperatureSensor::~TemperatureSensor()
{
    if (m_i2cFileDescriptor >= 0)
    {
        constexpr unsigned char stopPeriodicMeasurement[2] = {0x3F, 0x86};
        write(m_i2cFileDescriptor, stopPeriodicMeasurement, 2);
        close(m_i2cFileDescriptor);
    }

    if (m_database.isOpen())
    {
        m_database.close();
        QSqlDatabase::removeDatabase("EnvironmentData");
    }
}

double TemperatureSensor::temperature() const
{
    return m_currentTemperature;
}

double TemperatureSensor::co2() const
{
    return m_currentCo2;
}

double TemperatureSensor::humidity() const
{
    return m_currentHumidity;
}

void TemperatureSensor::readTemperature()
{
    if (m_i2cFileDescriptor < 0) return;
    if (!isDataReady()) return;

    unsigned char readMeasurement[2] = {0xEC, 0x05};
    unsigned char buffer[9] = {};

    i2c_msg msgs[2];
    msgs[0].addr = SCD41_ADDR;
    msgs[0].flags = 0;
    msgs[0].len = 2;
    msgs[0].buf = readMeasurement;

    msgs[1].addr = SCD41_ADDR;
    msgs[1].flags = I2C_M_RD;
    msgs[1].len = 9;
    msgs[1].buf = buffer;

    i2c_rdwr_ioctl_data msgset{};
    msgset.msgs = msgs;
    msgset.nmsgs = 2;

    if (ioctl(m_i2cFileDescriptor, I2C_RDWR, &msgset) >= 0)
    {
        const uint16_t rawTemperature = (buffer[3] << 8) | buffer[4];
        const uint16_t rawCo2 = (buffer[0] << 8) | buffer[1];
        const uint16_t rawHumidity = (buffer[6] << 8) | buffer[7];

        const double celsius = -45.0 + 175.0 * (static_cast<double>(rawTemperature) / 65536.0);
        const double co2 = rawCo2;
        const double humidity = 100.0 * (static_cast<double>(rawHumidity) / 65536.0f);

        if (!qFuzzyCompare(m_currentTemperature, celsius))
        {
            m_currentTemperature = celsius;
            emit temperatureChanged(m_currentTemperature);
        }
        if (!qFuzzyCompare(m_currentCo2, co2))
        {
            m_currentCo2 = co2;
            emit co2Changed(m_currentCo2);
        }
        if (!qFuzzyCompare(m_currentHumidity, humidity))
        {
            m_currentHumidity = humidity;
            emit humidityChanged(m_currentHumidity);
        }
    }
}

bool TemperatureSensor::isDataReady() const
{
    if (m_i2cFileDescriptor < 0)return false;
    uint8_t getDataReadyStatus[2] = {0xE4, 0xB8};
    uint8_t dataReadyStatusBuffer[3];
    i2c_msg msgs[2];
    msgs[0].addr = SCD41_ADDR;
    msgs[0].flags = 0;
    msgs[0].len = 2;
    msgs[0].buf = getDataReadyStatus;

    msgs[1].addr = SCD41_ADDR;
    msgs[1].flags = I2C_M_RD;
    msgs[1].len = 3;
    msgs[1].buf = dataReadyStatusBuffer;

    i2c_rdwr_ioctl_data msgset{};
    msgset.msgs = msgs;
    msgset.nmsgs = 2;

    if (ioctl(m_i2cFileDescriptor, I2C_RDWR, &msgset) >= 0)
    {
        const uint16_t status = (dataReadyStatusBuffer[0] << 8) | dataReadyStatusBuffer[1];
        return (status & 0x07FF) != 0;
    }
    return false;
}

void TemperatureSensor::insertDataToDatabase() const
{
    QSqlQuery query{m_database};
    query.prepare("INSERT INTO metrics (temperature, co2, humidity) VALUES (:temperature, :co2, :humidity)");
    query.bindValue(":temperature", m_currentTemperature);
    query.bindValue(":co2", m_currentCo2);
    query.bindValue(":humidity", m_currentHumidity);

    if (!query.exec())
    {
        qWarning() << "Could not write to database:" << query.lastError().text();
    }
}
