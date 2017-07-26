#ifndef SQLMOLENETMODEL_H
#define SQLMOLENETMODEL_H

#include <QSqlTableModel>

class SqlMoleNetModel : public QSqlTableModel
{
    Q_OBJECT
    Q_PROPERTY(bool onlySourceIDCol READ getSourceIdColumn WRITE setSourceIdColumn NOTIFY sourceIdColumnChanged)
    Q_ENUMS(CHAT_STATUS)

public:
   SqlMoleNetModel(QObject *parent = 0);

   int listStatus() const;
    void setListStatus(int status);
   QVariant data(const QModelIndex &index, int role) const Q_DECL_OVERRIDE;
   QHash<int, QByteArray> roleNames() const Q_DECL_OVERRIDE;

   Q_INVOKABLE void insertData(const QVariant &jsonStr);
   Q_INVOKABLE void loadData();
   Q_INVOKABLE void clearTables();
   Q_INVOKABLE void loadNodeIDs();
   Q_INVOKABLE void loadSingleNode(const QString &node_id);

   // TODO
   Q_INVOKABLE void updateChatData(QJsonObject *jObjj);
   Q_INVOKABLE void plotData(QList<QVector<QPointF>> *listData,const QString& node_id,const QString& type);
    Q_INVOKABLE void loadSingleReading(const QString &reading_id);
  // enum CHAT_STATUS{PENDING,ACTIVE,CLOSED,BLOCKED};
  // enum COLUMN_NUM{id, nick, email, ip,time,last_msg_id,user_id,status,country_code,country_name,referrer,
  //                 hash,user_typing,user_typing_txt,uagent
  //     };
   static constexpr const char* TEMPERATURE = "temperature";
   static  constexpr const char* DIELECTRIC = "dielectric";

  void setSourceIdColumn(bool val){ m_sourceIdColumn = val; emit sourceIdColumnChanged(); }
  bool getSourceIdColumn(){ return m_sourceIdColumn; }

  int m_last_row;


public slots:

signals:
   void sourceIdColumnChanged();

protected:

private:
   bool m_sourceIdColumn;
};

#endif // SQLCHATMODEL_H
