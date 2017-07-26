#include "sqlmolenetmodel.h"

#include <QDebug>
#include <QSqlError>
#include <QSqlRecord>
#include <QSqlQuery>
#include <QJsonObject>
#include <QJsonDocument>
#include <QDateTime>
#include <QAbstractSeries>

#include <QVector>




static const QString chatsTableName = "molenet_data";


// the order must match enum COLUMN_NUM order as well as order of table columns in lhc_chats table
static const char *COLUMN_NAMES[] ={"id","sink_id","source_id", "epoch","time","temperature","dielectric","packet_lost",
                                    "rtt","rssi","sending_retries","eepromNextPage"};

static void createTable()
{
    if (QSqlDatabase::database().tables().contains(chatsTableName)) {
        // The table already exists; we don't need to do anything.
        return;
    }

    QSqlQuery query;
    if (!query.exec(
                "CREATE TABLE IF NOT EXISTS '"+chatsTableName+"' ("
                "'id'INTEGER PRIMARY KEY AUTOINCREMENT,"
                "'sink_id' TEXT,"
                "'source_id' TEXT,"
                "'epoch' TEXT,"
                "'time' TEXT,"
                "'temperature' TEXT,"
                "'dielectric' TEXT,"
                "'packet_lost' TEXT,"
                "'rtt' TEXT,"
                "'rssi' TEXT,"
                "'sending_retries' TEXT,"
                "'eepromNextPage' TEXT"
                ")")) {
        qFatal("Failed to query database: %s", qPrintable(query.lastError().text()));
    }

    //  query.exec("INSERT INTO lhc_chats ('id','nick','email','ip') VALUES(1,'Albert','me@chat.com','123.212.23.43')");
    // query.exec("INSERT INTO lhc_chats ('id','nick','email','ip') VALUES(2,'Kwame','me@chat.com','123.212.23.43')");

}


SqlMoleNetModel::SqlMoleNetModel(QObject *parent): QSqlTableModel(parent)

{
    createTable();
    setTable(chatsTableName);
    setSort(0,Qt::DescendingOrder);
    setEditStrategy(QSqlTableModel::OnRowChange);
    m_sourceIdColumn = false;
    m_last_row = 0;

 //   connect(this,SIGNAL(listStatusChanged()),this,SLOT(refreshList()));
}


QVariant SqlMoleNetModel::data(const QModelIndex &index, int role) const
{
    if (role < Qt::UserRole)
        return QSqlTableModel::data(index, role);

    const QSqlRecord sqlRecord = record(index.row());
    return sqlRecord.value(role - Qt::UserRole);
}

QHash<int, QByteArray> SqlMoleNetModel::roleNames() const
{
    QHash<int, QByteArray> names;

    if(m_sourceIdColumn)
    {
         names[Qt::UserRole] = COLUMN_NAMES[2];
    }
    else {
        int numCols = sizeof(COLUMN_NAMES)/sizeof(COLUMN_NAMES[0]);
        for(int i=0; i<numCols; i++)
        {
            names[Qt::UserRole + i] = COLUMN_NAMES[i];
        }
    }
    return names;
}


static QJsonObject ObjectFromString(const QString& in)
{
    QJsonObject obj;

    QJsonDocument doc = QJsonDocument::fromJson(QString(in).toUtf8());

    // check validity of the document
    if(!doc.isNull())
    {
        //   qDebug() << doc.toJson().toStdString();
        if(doc.isObject())
        {
            obj = doc.object();
        }
        else
        {
            //obj = NULL;
            qDebug() << "Document is not an object" << endl;
        }
    }
    else
    {
        qDebug() << "Invalid JSON...\n" << in << endl;

    }

    return obj;
}


void SqlMoleNetModel::insertData(const QVariant &jsonStr)
{
    QString qstr (jsonStr.toString());


    QJsonObject jsonObj =  ObjectFromString(QString(qstr).simplified());

    int colCount = sizeof(COLUMN_NAMES)/sizeof(COLUMN_NAMES[0]);

    // populate newRecord with the columns and their corresponding values
    QSqlRecord newRecord = record();

    for(int i=1; i<colCount; i++)
    {
        // QString fieldValue = !jsonObj.value(QString(COLUMN_NAMES[i])).isUndefined() ? "": ;

        newRecord.setValue(COLUMN_NAMES[i],jsonObj.value(QString(COLUMN_NAMES[i])).toString());

          qDebug() <<COLUMN_NAMES[i] << ":" << jsonObj[COLUMN_NAMES[i]].toString() << "\n";
    }

    if (!insertRecord(rowCount(), newRecord)) {
        qWarning() << "Failed to save data:" << lastError().text();
        return;
    }

}




void SqlMoleNetModel::loadData()
{
    //  qDebug() << "Status: " << status;
    //  const QString filterString = QString::fromLatin1("(id = '%1')").arg(chatID);
    // setFilter(filterString);
    select();
}


void SqlMoleNetModel::plotData(QList<QVector<QPointF>> *listData,const QString& node_id,const QString& type)
{

  //  qDebug() << "m_lastrow: " << m_last_row << "node_d: " << node_id;

    QSqlQuery qchk;
    if(type == SqlMoleNetModel::TEMPERATURE)
    {
    qchk.prepare("SELECT id,temperature,time FROM '"+chatsTableName+"'  where id > :id and source_id=:source_id");
    }
    else
      {  qchk.prepare("SELECT id,dielectric,time FROM '"+chatsTableName+"'  where id > :id and source_id=:source_id");
       }
        qchk.bindValue(":id",m_last_row);
    qchk.bindValue(":source_id",node_id);
    qchk.exec();


    int count=0;

    QVariantMap map;
   // map.insert("language", "QML");
   // map.insert("released", QDate(2010, 9, 21));

    while(qchk.next())
       {
        count++;
         qreal y(qchk.value(1).toInt());
         qreal x(0);
          QString ystr(qchk.value(2).toString());
            qDebug() << "dateString :" << ystr;
        QDateTime xDate = QDateTime::fromString(ystr);
      qDebug() <<"xDate: " << xDate.date() ;
        x = static_cast<double>(xDate.toMSecsSinceEpoch());
        qDebug() <<"x: " << QString::number(x) << " y: " << y ;
       //   qDebug() <<"x: "<<x;

           QVector<QPointF> points;
           points.append(QPointF(x, y));

          // map.insert();

           listData->append(points);
        // Save last id to be used to resume
        m_last_row = qchk.value(0).toInt();
       }

}


void SqlMoleNetModel::updateChatData(QJsonObject *jObjj)
{
    foreach (const QJsonValue & value, *jObjj) {
        QJsonObject obj = value.toObject();

        // we will set the value of "status" value manually. Subtract 1 from the length

        int colCount = sizeof(COLUMN_NAMES)/sizeof(COLUMN_NAMES[0]);
        QSqlRecord newRecord = record();
        for(int i=0; i<colCount-1; i++)
        {

            // check if chat doesn't already exist
            QSqlQuery qchk;
            qchk.prepare("SELECT * FROM '"+chatsTableName+"' WHERE id=:chatid");
            qchk.bindValue(":chatid",obj["id"].toInt());
            qchk.exec();
            if(qchk.record().count() > 0)
            {

            }
            else {
                //          newRecord.setValue(COLUMN_NAMES[i],obj[COLUMN_NAMES[i]].toString());
            }
        }

        if (!insertRecord(rowCount(), newRecord)) {
            qWarning() << "Failed to save chat:" << lastError().text();
            return;
        }
    }

    QSqlQuery qquery;
    qquery.prepare("UPDATE '"+chatsTableName+"' SET isLoggedIn=:isLogin");
    qquery.bindValue(":isLogin",static_cast<int>(true));
    if (!qquery.exec())
    {
        qFatal("Failed to update database: %s", qPrintable(qquery.lastError().text()));
    }
}

void SqlMoleNetModel::clearTables()
{
    QSqlQuery qry;
    qry.exec("DELETE FROM "+chatsTableName);
}



void SqlMoleNetModel::loadNodeIDs()
{
    m_sourceIdColumn = true;
    QSqlQuery qchk;
    qchk.prepare("SELECT DISTINCT source_id FROM '"+chatsTableName+"' order by source_id desc");
    qchk.exec();
    setQuery(qchk);

    m_sourceIdColumn = false;
}
void SqlMoleNetModel::loadSingleNode(const QString &node_id)
{
    //  qDebug() << "Status: " << status;
    const QString filterString = QString::fromLatin1("(source_id = '%1')").arg(node_id);
    setFilter(filterString);
    select();
}

void SqlMoleNetModel::loadSingleReading(const QString &reading_id)
{
    qDebug() << "reading id: " << reading_id;
    //  qDebug() << "Status: " << status;
    const QString filterString = QString::fromLatin1("(id = '%1')").arg(reading_id);
    setFilter(filterString);
    select();
}
