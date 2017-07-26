#ifndef RADIORFM69_H
#define RADIORFM69_H

#include <QObject>
#include <QQmlEngine>
#include "sqlmolenetmodel.h"

class MoleNet : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString radioData READ getRadioData WRITE setRadioData NOTIFY radioDataChanged)

public:
     ~MoleNet();
  //  Q_DISABLE_COPY(MoleNet)

    static QObject* moleNetProvider(QQmlEngine *engine, QJSEngine *scriptEngine);
    static MoleNet* instance();
    void setRadioData(const QString& radData);
  QString getRadioData(){ return m_radioData; }

    Q_INVOKABLE void openUSBCon(bool open);

     SqlMoleNetModel sqlModel ;
signals:
    void radioDataChanged();

public slots:
    void updateRadioData();

private:
    MoleNet(QObject *parent=0);


    QString m_radioData;

};

#endif // RADIORFM69_H
