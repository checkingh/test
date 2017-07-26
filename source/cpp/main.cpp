#include <QApplication>
#include <QQuickView>
#include <QtQml>
#include <QDir>
#include <QQmlEngine>

#include <QStandardPaths>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSplineSeries>
#include <QLineSeries>


//#include "misc/sqlmolenetmodel.h"
#include "misc/molenet.h"
#include "misc/datasource.h"
#include "misc/molenetchart.h"


static void connectToDatabase()
{
    QSqlDatabase database = QSqlDatabase::database();
    if (!database.isValid()) {
        database = QSqlDatabase::addDatabase("QSQLITE");
        if (!database.isValid())
            qFatal("Cannot add database: %s", qPrintable(database.lastError().text()));
    }

    const QDir writeDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    if (!writeDir.mkpath("."))
        qFatal("Failed to create writable directory at %s", qPrintable(writeDir.absolutePath()));

    // Ensure that we have a writable location on all devices.
    const QString fileName = writeDir.absolutePath() + "/molenet-database.sqlite3";
    // When using the SQLite driver, open() will create the SQLite database if it doesn't exist.

//  QFile::remove(fileName);   // REMOVE THIS LINE

    database.setDatabaseName(fileName);
  /* */
    if (!database.open()) {
        qFatal("Cannot open database: %s", qPrintable(database.lastError().text()));
        QFile::remove(fileName);
    }

}

QT_CHARTS_USE_NAMESPACE

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

    connectToDatabase();


    // expose PushNotification to qml
    qmlRegisterSingletonType<MoleNet>("com.comnet.molenet", 1, 0, "MoleNet",
                                                                       MoleNet::moleNetProvider);

    qmlRegisterType<SqlMoleNetModel>("com.comnet.molenet", 1, 0, "SqlMoleNetModel");
      qmlRegisterType<SqlMoleNetModel>("com.comnet.molenet", 1, 0, "SqlMoleNetNodeReading");
     qmlRegisterType<MoleNetChart>("com.comnet.molenet", 1, 0, "ChartDataSource");


      QQmlApplicationEngine engine;
      engine.rootContext()->setContextProperty("MmoleNet",MoleNet::instance());

      DataSource dataSourceTemp(&engine);
      engine.rootContext()->setContextProperty("dataSourceTemp", &dataSourceTemp);

      DataSource dataSourceDiel(&engine);
      engine.rootContext()->setContextProperty("dataSourceDiel", &dataSourceDiel);

      QLineSeries *series = new QLineSeries();
      series->append(0, 6);
      series->append(2, 4);

      engine.rootContext()->setContextProperty("QLineSeriesTemp",series);

    // open connection


    if (QApplication::arguments().count() > 1){
           qDebug() << "I am the service";
       }
       else{

           engine.load(QUrl(QLatin1String("qrc:/source/qml/main.qml")));
    }
    return app.exec();
}
